//
//  DiscoListFactory.swift
//  Main
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation
import Infra
import Data
import Domain
import Presentation
import UI
import UIKit

struct DiscoListFactory {
    static func make(
        navigationController: UINavigationController
    ) -> DiscoListViewController {
        let discoStorage = InMemoryDiscoStorage(database: InMemoryDatabase.instance)
        let discoService = DiscoServiceImpl(storage: discoStorage)
        let createNewDiscoUseCase = CreateNewDiscoUseCase(service: discoService)
        let getDiscosUseCase = GetDiscosUseCase(service: discoService)

        let interactor = DiscoListInteractor(
            getDiscosUseCase: getDiscosUseCase,
            createNewDiscoUseCase: createNewDiscoUseCase
        )
        let presenter = DiscoListPresenter()
        let viewController = DiscoListViewController(interactor: interactor)

        let router = DiscoListViewRouter(
            navigationController: navigationController,
            discoProfileViewController: DiscoProfileFactory.make
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
        assert(self.instance != nil)
        self.instance?.startLoading()
    }

    func hideLoading() {
        assert(self.instance != nil)
        self.instance?.hideLoading()
    }

    func hideOverlays(completion: (() -> Void)?) {
        assert(self.instance != nil)
        self.instance?.hideOverlays(completion: completion)
    }

    func showDiscos(_ discos: [Presentation.DiscoListViewEntity]) {
        assert(self.instance != nil)
        self.instance?.showDiscos(discos)
    }

    func showNewDisco(_ disco: Presentation.DiscoListViewEntity) {
        assert(self.instance != nil)
        self.instance?.showNewDisco(disco)
    }

    func createDiscoError(_ title: String, _ description: String) {
        assert(self.instance != nil)
        self.instance?.createDiscoError(title, description)

    }

    func loadDiscoError(_ title: String, _ description: String) {
        assert(self.instance != nil)
        self.instance?.loadDiscoError(title, description)
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
    
    func showDiscos(_ discos: [Presentation.DiscoListViewEntity]) {
        DispatchQueue.main.async {
            self.instance.showDiscos(discos)
        }
    }
    
    func showNewDisco(_ disco: Presentation.DiscoListViewEntity) {
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
