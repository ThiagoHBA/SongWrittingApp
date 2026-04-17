import Foundation

protocol DiscoProfileBusinessLogic: AnyObject {
    func searchNewReferences(keywords: String)
    func loadProfile(for disco: DiscoSummary)
    func addNewReferences(for disco: DiscoSummary, references: [AlbumReferenceViewEntity])
    func addNewSection(for disco: DiscoSummary, section: SectionViewEntity)
    func addNewRecord(in disco: DiscoSummary, to section: SectionViewEntity)
}

final class DiscoProfileInteractor: DiscoProfileBusinessLogic {
    private let searchReferencesUseCase: SearchReferencesUseCase
    private let getDiscoProfileUseCase: GetDiscoProfileUseCase
    private let addDiscoNewReferenceUseCase: AddDiscoNewReferenceUseCase
    private let addNewSectionToDiscoUseCase: AddNewSectionToDiscoUseCase
    private let addNewRecordToSessionUseCase: AddNewRecordToSessionUseCase

    var presenter: DiscoProfilePresentationLogic?

    init(
        searchReferencesUseCase: SearchReferencesUseCase,
        getDiscoProfileUseCase: GetDiscoProfileUseCase,
        addDiscoNewReferenceUseCase: AddDiscoNewReferenceUseCase,
        addNewSectionToDiscoUseCase: AddNewSectionToDiscoUseCase,
        addNewRecordToSessionUseCase: AddNewRecordToSessionUseCase
    ) {
        self.searchReferencesUseCase = searchReferencesUseCase
        self.getDiscoProfileUseCase = getDiscoProfileUseCase
        self.addDiscoNewReferenceUseCase = addDiscoNewReferenceUseCase
        self.addNewSectionToDiscoUseCase = addNewSectionToDiscoUseCase
        self.addNewRecordToSessionUseCase = addNewRecordToSessionUseCase
    }

    func searchNewReferences(keywords: String) {
        presenter?.presentLoading()
        
        searchReferencesUseCase.search(.init(keywords)) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let references):
                self.presenter?.presentFoundReferences(references)
            case .failure(let error):
                self.presenter?.presentFindReferencesError(error)
            }
        }
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

    func addNewRecord(in disco: DiscoSummary, to section: SectionViewEntity) {
        presenter?.presentLoading()
        
        do {
            let section = try section.mapToDomain()
            
            let input = AddNewRecordToSessionUseCaseInput(
                disco: disco,
                section: section
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
        } catch {
            self.presenter?.presentAddRecordError(error)
        }
    }
}
