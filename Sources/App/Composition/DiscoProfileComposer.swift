import UIKit

enum DiscoProfileComposer {
    static func make(with disco: DiscoSummary) -> UIViewController {
        let networkClient = NetworkClientImpl()
        let secureClient = SecureClientImpl(server: SpotifyReferencesConstants.secureStorageServer)
        let authorizationHandler = SpotifyAuthorizationHandlerImpl(
            networkClient: networkClient,
            secureClient: secureClient
        )
        let authorizedClient = AuthorizationDecorator(
            client: networkClient,
            tokenProvider: authorizationHandler
        )

        let spotifyReferenceSearchRepository = SpotifyReferenceSearchRepository(networkClient: authorizedClient)
        let lastFMReferenceSearchRepository = LastFMReferenceSearchRepository(networkClient: networkClient)
        let referenceSearchRepository = ReferenceSearchStrategyRegistry(
            spotify: spotifyReferenceSearchRepository,
            lastFM: lastFMReferenceSearchRepository
        )
        let coreDataStore = try? CoreDataDiscoStore()
        let discoStore = InMemoryDiscoStore(database: InMemoryDatabase.instance)
        let discoProfileRepository = DiscoProfileRepositoryImpl(store: coreDataStore ?? discoStore)

        let presenter = DiscoProfilePresenter()
        let interactor = DiscoProfileInteractor(
            searchReferencesUseCase: referenceSearchRepository,
            getDiscoProfileUseCase: discoProfileRepository,
            addDiscoNewReferenceUseCase: discoProfileRepository,
            addNewSectionToDiscoUseCase: discoProfileRepository,
            addNewRecordToSessionUseCase: discoProfileRepository
        )
        let viewController = DiscoProfileViewController(disco: disco, interactor: interactor)

        interactor.presenter = presenter
        presenter.view = MainQueueProxy(WeakReferenceProxy(viewController))

        return viewController
    }
}

extension WeakReferenceProxy: DiscoProfileDisplayLogic where T: DiscoProfileDisplayLogic {
    func showSearchProviders(
        _ providers: [SearchReferenceViewEntity],
        selectedProvider: SearchReferenceViewEntity
    ) {
        instance?.showSearchProviders(providers, selectedProvider: selectedProvider)
    }

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

    func showReferences(_ references: ReferenceSearchViewEntity) {
        instance?.showReferences(references)
    }
}

extension MainQueueProxy: DiscoProfileDisplayLogic where T: DiscoProfileDisplayLogic {
    func showSearchProviders(
        _ providers: [SearchReferenceViewEntity],
        selectedProvider: SearchReferenceViewEntity
    ) {
        DispatchQueue.main.async {
            self.instance.showSearchProviders(providers, selectedProvider: selectedProvider)
        }
    }

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

    func showReferences(_ references: ReferenceSearchViewEntity) {
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
