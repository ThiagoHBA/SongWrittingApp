import UIKit

enum DiscoListComposer {
    static func make(
        navigationController: UINavigationController,
        container: DiscoListContainer = DiscoListContainer(app: .shared)
    ) -> UIViewController {
        let repository = container.repository

        let getDiscosUseCase = repository
        let createNewDiscoUseCase = repository
        let deleteDiscoUseCase = container.deleteDiscoUseCase
        let getDiscoReferencesUseCase = container.getDiscoReferencesUseCase

        let interactor = DiscoListInteractor(
            getDiscosUseCase: getDiscosUseCase,
            createNewDiscoUseCase: createNewDiscoUseCase,
            deleteDiscoUseCase: deleteDiscoUseCase,
            getDiscoReferencesUseCase: getDiscoReferencesUseCase
        )
        let presenter = DiscoListPresenter()
        let viewController = DiscoListViewController(interactor: interactor)

        let router = DiscoListRouter(
            navigationController: navigationController,
            discoProfileViewController: { disco in
                DiscoProfileComposer.make(
                    with: disco,
                    container: container.discoProfileContainer
                )
            }
        )

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

    func removeDisco(_ disco: DiscoListViewEntity) {
        instance?.removeDisco(disco)
    }

    func deleteDiscoError(_ title: String, _ description: String) {
        instance?.deleteDiscoError(title, description)
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

    func removeDisco(_ disco: DiscoListViewEntity) {
        DispatchQueue.main.async {
            self.instance.removeDisco(disco)
        }
    }

    func deleteDiscoError(_ title: String, _ description: String) {
        DispatchQueue.main.async {
            self.instance.deleteDiscoError(title, description)
        }
    }
}
