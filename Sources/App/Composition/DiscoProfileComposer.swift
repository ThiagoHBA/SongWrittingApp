import UIKit

enum DiscoProfileComposer {
    static func make(with disco: DiscoSummary) -> UIViewController {
        let networkClient = NetworkClientImpl()
        let secureClient = SecureClientImpl(server: SpotifyReferencesConstants.secureStorageServer)
        let authorizationHandler = AuthorizationHandlerImpl(
            networkClient: networkClient,
            secureClient: secureClient
        )
        let authorizedClient = AuthorizationDecorator(
            client: networkClient,
            tokenProvider: authorizationHandler
        )

        let referenceSearchRepository = SpotifyReferenceSearchRepository(networkClient: authorizedClient)
        let discoStore = InMemoryDiscoStore(database: InMemoryDatabase.instance)
        let discoProfileRepository = DiscoProfileRepositoryImpl(store: discoStore)

        let searchReferencesUseCase = SearchReferencesUseCase(repository: referenceSearchRepository)
        let getDiscoProfileUseCase = GetDiscoProfileUseCase(repository: discoProfileRepository)
        let addDiscoNewReferencesUseCase = AddDiscoNewReferenceUseCase(repository: discoProfileRepository)
        let addNewSectionUseCase = AddNewSectionToDiscoUseCase(repository: discoProfileRepository)
        let addNewRecordToSectionUseCase = AddNewRecordToSessionUseCase(repository: discoProfileRepository)

        let presenter = DiscoProfilePresenter()
        let interactor = DiscoProfileInteractor(
            searchReferencesUseCase: searchReferencesUseCase,
            getDiscoProfileUseCase: getDiscoProfileUseCase,
            addDiscoNewReferenceUseCase: addDiscoNewReferencesUseCase,
            addNewSectionToDiscoUseCase: addNewSectionUseCase,
            addNewRecordToSessionUseCase: addNewRecordToSectionUseCase
        )
        let viewController = DiscoProfileViewController(disco: disco, interactor: interactor)

        searchReferencesUseCase.output = [presenter]
        getDiscoProfileUseCase.output = [presenter]
        addDiscoNewReferencesUseCase.output = [presenter]
        addNewSectionUseCase.output = [presenter]
        addNewRecordToSectionUseCase.output = [presenter]

        interactor.presenter = presenter
        presenter.view = MainQueueProxy(WeakReferenceProxy(viewController))

        return viewController
    }
}

extension WeakReferenceProxy: DiscoProfileDisplayLogic where T: DiscoProfileDisplayLogic {
    func addingRecordsError(_ title: String, description: String) {
        instance?.addingRecordsError(title, description: description)
    }

    func hideOverlays(completion: (() -> Void)?) {
        instance?.hideOverlays(completion: completion)
    }

    func updateSections(_ sections: [SectionViewEntity]) {
        instance?.updateSections(sections)
    }

    func addingSectionError(_ title: String, description: String) {
        instance?.addingSectionError(title, description: description)
    }

    func updateReferences(_ references: [AlbumReferenceViewEntity]) {
        instance?.updateReferences(references)
    }

    func showProfile(_ profile: DiscoProfileViewEntity) {
        instance?.showProfile(profile)
    }

    func addingReferencesError(_ title: String, description: String) {
        instance?.addingReferencesError(title, description: description)
    }

    func loadingProfileError(_ title: String, description: String) {
        instance?.loadingProfileError(title, description: description)
    }

    func startLoading() {
        instance?.startLoading()
    }

    func hideLoading() {
        instance?.hideLoading()
    }

    func showReferences(_ references: [AlbumReferenceViewEntity]) {
        instance?.showReferences(references)
    }
}

extension MainQueueProxy: DiscoProfileDisplayLogic where T: DiscoProfileDisplayLogic {
    func startLoading() {
        DispatchQueue.main.async {
            self.instance.startLoading()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.instance.hideLoading()
        }
    }

    func hideOverlays(completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.instance.hideOverlays(completion: completion)
        }
    }

    func showReferences(_ references: [AlbumReferenceViewEntity]) {
        DispatchQueue.main.async {
            self.instance.showReferences(references)
        }
    }

    func showProfile(_ profile: DiscoProfileViewEntity) {
        DispatchQueue.main.async {
            self.instance.showProfile(profile)
        }
    }

    func updateReferences(_ references: [AlbumReferenceViewEntity]) {
        DispatchQueue.main.async {
            self.instance.updateReferences(references)
        }
    }

    func updateSections(_ sections: [SectionViewEntity]) {
        DispatchQueue.main.async {
            self.instance.updateSections(sections)
        }
    }

    func addingReferencesError(_ title: String, description: String) {
        DispatchQueue.main.async {
            self.instance.addingReferencesError(title, description: description)
        }
    }

    func addingSectionError(_ title: String, description: String) {
        DispatchQueue.main.async {
            self.instance.addingSectionError(title, description: description)
        }
    }

    func loadingProfileError(_ title: String, description: String) {
        DispatchQueue.main.async {
            self.instance.loadingProfileError(title, description: description)
        }
    }

    func addingRecordsError(_ title: String, description: String) {
        DispatchQueue.main.async {
            self.instance.addingRecordsError(title, description: description)
        }
    }
}
