import Foundation

protocol DiscoProfileBusinessLogic: AnyObject {
    func loadSearchProviders()
    func searchNewReferences(keywords: String)
    func selectReferenceProvider(_ provider: SearchReferenceViewEntity)
    func loadMoreReferences()
    func resetReferenceSearch()
    func loadProfile(for disco: DiscoSummary)
    func addNewReferences(for disco: DiscoSummary, references: [AlbumReferenceViewEntity])
    func addNewSection(for disco: DiscoSummary, section: SectionViewEntity)
    func addNewRecord(in disco: DiscoSummary, to sectionIdentifier: String, audioFileURL: URL)
    func updateDiscoName(disco: DiscoSummary, newName: String)
    func deleteDisco(_ disco: DiscoSummary)
}

final class DiscoProfileInteractor: DiscoProfileBusinessLogic {
    private let searchReferencesUseCase: SearchReferencesUseCase
    private let getDiscoProfileUseCase: GetDiscoProfileUseCase
    private let addDiscoNewReferenceUseCase: AddDiscoNewReferenceUseCase
    private let addNewSectionToDiscoUseCase: AddNewSectionToDiscoUseCase
    private let addNewRecordToSessionUseCase: AddNewRecordToSessionUseCase
    private let updateDiscoNameUseCase: UpdateDiscoNameUseCase
    private let deleteDiscoUseCase: DeleteDiscoUseCase

    private var currentReferenceProvider: ReferenceProvider = .spotify
    private var loadedReferences: [AlbumReference] = []
    private var hasMoreReferencePages = false
    private var hasActiveReferenceSearch = false
    private var activeReferenceSearchRequestID: UUID?

    var presenter: DiscoProfilePresentationLogic?

    init(
        searchReferencesUseCase: SearchReferencesUseCase,
        getDiscoProfileUseCase: GetDiscoProfileUseCase,
        addDiscoNewReferenceUseCase: AddDiscoNewReferenceUseCase,
        addNewSectionToDiscoUseCase: AddNewSectionToDiscoUseCase,
        addNewRecordToSessionUseCase: AddNewRecordToSessionUseCase,
        updateDiscoNameUseCase: UpdateDiscoNameUseCase,
        deleteDiscoUseCase: DeleteDiscoUseCase
    ) {
        self.searchReferencesUseCase = searchReferencesUseCase
        self.getDiscoProfileUseCase = getDiscoProfileUseCase
        self.addDiscoNewReferenceUseCase = addDiscoNewReferenceUseCase
        self.addNewSectionToDiscoUseCase = addNewSectionToDiscoUseCase
        self.addNewRecordToSessionUseCase = addNewRecordToSessionUseCase
        self.updateDiscoNameUseCase = updateDiscoNameUseCase
        self.deleteDiscoUseCase = deleteDiscoUseCase
    }

    func loadSearchProviders() {
        let providers = ReferenceProvider.allCases.map(SearchReferenceViewEntity.init(from:))
        let selectedProvider = SearchReferenceViewEntity(from: currentReferenceProvider)
        presenter?.presentSearchProviders(providers, selectedProvider: selectedProvider)
    }

    func searchNewReferences(keywords: String) {
        let keywords = keywords.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !keywords.isEmpty else {
            resetReferenceSearch()
            return
        }

        presenter?.presentLoading()

        hasActiveReferenceSearch = true
        loadedReferences = []
        hasMoreReferencePages = false

        requestFirstReferencesPage(for: keywords)
    }

    func selectReferenceProvider(_ provider: SearchReferenceViewEntity) {
        guard let mappedProvider = ReferenceProvider(rawValue: provider.id),
              currentReferenceProvider != mappedProvider else {
            return
        }

        currentReferenceProvider = mappedProvider
        resetReferenceSearch()
        loadSearchProviders()
    }

    func loadMoreReferences() {
        guard hasActiveReferenceSearch,
              hasMoreReferencePages,
              activeReferenceSearchRequestID == nil else {
            return
        }

        requestMoreReferences()
    }

    func resetReferenceSearch() {
        hasActiveReferenceSearch = false
        loadedReferences = []
        hasMoreReferencePages = false
        activeReferenceSearchRequestID = nil
        searchReferencesUseCase.reset()
    }

    func loadProfile(for disco: DiscoSummary) {
        presenter?.presentLoading()
        
        getDiscoProfileUseCase.load(disco) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                self.presenter?.presentLoadedProfile(profile)
            case .failure(let error):
                self.presenter?.presentLoadProfileError(error)
            }
        }
    }

    func addNewReferences(for disco: DiscoSummary, references: [AlbumReferenceViewEntity]) {
        presenter?.presentLoading()
        
        addDiscoNewReferenceUseCase.addReferences(.init(
            disco: disco,
            newReferences: references.map { $0.mapToDomain() }
        )) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                self.presenter?.presentAddedReferences(profile)
            case .failure(let error):
                self.presenter?.presentAddReferencesError(error)
            }
        }
    }

    func addNewSection(for disco: DiscoSummary, section: SectionViewEntity) {
        presenter?.presentLoading()
        
        do {
            let section = try section.mapToDomain()
            
            let input = AddNewSectionToDiscoUseCaseInput(
                disco: disco,
                section: section
            )
            
            addNewSectionToDiscoUseCase.addSection(input) { [weak self] result in
                guard let self else { return }

                switch result {
                case .success(let profile):
                    self.presenter?.presentAddedSection(profile)
                case .failure(let error):
                    self.presenter?.presentAddSectionError(error)
                }
            }
        } catch let error as DiscoProfileError.CreateSectionError {
            presenter?.presentCreateSectionError(error)
        } catch {
            presenter?.presentAddSectionError(error)
        }
    }

    func addNewRecord(in disco: DiscoSummary, to sectionIdentifier: String, audioFileURL: URL) {
        presenter?.presentLoading()

        let input = AddNewRecordToSessionUseCaseInput(
            disco: disco,
            sectionIdentifier: sectionIdentifier,
            audioFileURL: audioFileURL
        )

        addNewRecordToSessionUseCase.addRecord(input) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                self.presenter?.presentAddedRecord(profile)
            case .failure(let error):
                self.presenter?.presentAddRecordError(error)
            }
        }
    }

    func updateDiscoName(disco: DiscoSummary, newName: String) {
        presenter?.presentLoading()

        updateDiscoNameUseCase.updateName(.init(disco: disco, newName: newName)) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let updatedDisco):
                self.presenter?.presentDiscoNameUpdated(updatedDisco)
            case .failure(let error):
                self.presenter?.presentUpdateDiscoNameError(error)
            }
        }
    }

    func deleteDisco(_ disco: DiscoSummary) {
        presenter?.presentLoading()

        deleteDiscoUseCase.delete(.init(disco: disco)) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                self.presenter?.presentDiscoDeleted()
            case .failure(let error):
                self.presenter?.presentDeleteDiscoError(error)
            }
        }
    }

    private func requestFirstReferencesPage(for keywords: String) {
        let requestID = UUID()
        activeReferenceSearchRequestID = requestID

        searchReferencesUseCase.search(
            .init(
                keywords: keywords,
                provider: currentReferenceProvider
            ),
            completion: handleReferencesResult(requestID: requestID, shouldReplaceLoadedReferences: true)
        )
    }

    private func requestMoreReferences() {
        let requestID = UUID()
        activeReferenceSearchRequestID = requestID

        searchReferencesUseCase.loadMore(
            completion: handleReferencesResult(requestID: requestID, shouldReplaceLoadedReferences: false)
        )
    }

    private func handleReferencesResult(
        requestID: UUID,
        shouldReplaceLoadedReferences: Bool
    ) -> (Result<SearchReferencesUseCaseOutput, Error>) -> Void {
        { [weak self] result in
            guard let self,
                  self.activeReferenceSearchRequestID == requestID else {
                return
            }

            self.activeReferenceSearchRequestID = nil

            switch result {
            case .success(let page):
                self.loadedReferences = shouldReplaceLoadedReferences
                    ? page.references
                    : self.loadedReferences + page.references
                self.hasMoreReferencePages = page.hasMore
                self.presenter?.presentFoundReferences(
                    SearchReferencesPage(
                        references: self.loadedReferences,
                        hasMore: page.hasMore
                    )
                )
            case .failure(let error):
                self.presenter?.presentFindReferencesError(error)
            }
        }
    }
}
