import UIKit

enum DiscoListComposer {
    static func make(
        navigationController: UINavigationController
    ) -> UIViewController {
        let discoStore = InMemoryDiscoStore(database: InMemoryDatabase.instance)
        let repository = DiscoListRepositoryImpl(store: discoStore)

        let createNewDiscoUseCase = CreateNewDiscoUseCase(repository: repository)
        let getDiscosUseCase = GetDiscosUseCase(repository: repository)

        let interactor = DiscoListInteractor(
            getDiscosUseCase: getDiscosUseCase,
            createNewDiscoUseCase: createNewDiscoUseCase
        )
        let presenter = DiscoListPresenter()
        let viewController = DiscoListViewController(interactor: interactor)

        let router = DiscoListRouter(
            navigationController: navigationController,
            discoProfileViewController: DiscoProfileComposer.make
        )

        createNewDiscoUseCase.output = [presenter]
        getDiscosUseCase.output = [presenter]

        interactor.router = router
        interactor.presenter = presenter
        presenter.view = MainQueueProxy(WeakReferenceProxy(viewController))

        return viewController
    }
}

extension WeakReferenceProxy: DiscoListDisplayLogic where T: DiscoListDisplayLogic {
    func startLoading() {
        instance?.startLoading()
    }

    func hideLoading() {
        instance?.hideLoading()
    }

    func hideOverlays(completion: (() -> Void)?) {
        instance?.hideOverlays(completion: completion)
    }

    func showDiscos(_ discos: [DiscoListViewEntity]) {
        instance?.showDiscos(discos)
    }

    func showNewDisco(_ disco: DiscoListViewEntity) {
        instance?.showNewDisco(disco)
    }

    func createDiscoError(_ title: String, _ description: String) {
        instance?.createDiscoError(title, description)
    }

    func loadDiscoError(_ title: String, _ description: String) {
        instance?.loadDiscoError(title, description)
    }
}

extension MainQueueProxy: DiscoListDisplayLogic where T: DiscoListDisplayLogic {
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

    func showDiscos(_ discos: [DiscoListViewEntity]) {
        DispatchQueue.main.async {
            self.instance.showDiscos(discos)
        }
    }

    func showNewDisco(_ disco: DiscoListViewEntity) {
        DispatchQueue.main.async {
            self.instance.showNewDisco(disco)
        }
    }

    func createDiscoError(_ title: String, _ description: String) {
        DispatchQueue.main.async {
            self.instance.createDiscoError(title, description)
        }
    }

    func loadDiscoError(_ title: String, _ description: String) {
        DispatchQueue.main.async {
            self.instance.loadDiscoError(title, description)
        }
    }
}
