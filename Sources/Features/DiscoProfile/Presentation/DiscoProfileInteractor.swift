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
        searchReferencesUseCase.input = .init(keywords: keywords)
        searchReferencesUseCase.execute()
    }

    func loadProfile(for disco: DiscoSummary) {
        presenter?.presentLoading()
        getDiscoProfileUseCase.input = .init(disco: disco)
        getDiscoProfileUseCase.execute()
    }

    func addNewReferences(for disco: DiscoSummary, references: [AlbumReferenceViewEntity]) {
        presenter?.presentLoading()
        addDiscoNewReferenceUseCase.input = .init(
            disco: disco,
            newReferences: references.map { $0.mapToDomain() }
        )
        addDiscoNewReferenceUseCase.execute()
    }

    func addNewSection(for disco: DiscoSummary, section: SectionViewEntity) {
        guard sectionIsValid(section.identifer) else { return }

        presenter?.presentLoading()
        addNewSectionToDiscoUseCase.input = .init(
            disco: disco,
            section: section.mapToDomain()
        )
        addNewSectionToDiscoUseCase.execute()
    }

    func addNewRecord(in disco: DiscoSummary, to section: SectionViewEntity) {
        presenter?.presentLoading()
        addNewRecordToSessionUseCase.input = .init(
            disco: disco,
            section: section.mapToDomain()
        )
        addNewRecordToSessionUseCase.execute()
    }

    private func sectionIsValid(_ name: String) -> Bool {
        if name.isEmpty {
            presenter?.presentCreateSectionError(.emptyName)
            return false
        }

        return true
    }
}
