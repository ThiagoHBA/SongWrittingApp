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
    static func make(navigationController: UINavigationController) -> DiscoListViewController {
        let discoService = DiscoServiceFromMemory()
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
        // Retain Cicle: I -> P -> V -> I
        interactor.router = router
        interactor.presenter = presenter
        presenter.view = viewController
        
        return viewController
    }
}
