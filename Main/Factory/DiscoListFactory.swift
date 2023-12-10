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

struct DiscoListFactory {
    static func make() -> DiscoListViewController {
        let networkClient = NetworkClientImpl()
        let discoService = DiscoServiceImpl(networkClient: networkClient)
        let createNewDiscoUseCase = CreateNewDiscoUseCase(service: discoService)
        let getDiscosUseCase = GetDiscosUseCase(service: discoService)
        
        let interactor = DiscoListInteractor(
            getDiscosUseCase: getDiscosUseCase,
            createNewDiscoUseCase: createNewDiscoUseCase
        )
        
        let presenter = DiscoListPresenter()
        let viewController = DiscoListViewController(interactor: interactor)
        
        // Possible Retain Cicle
        createNewDiscoUseCase.output = [presenter]
        getDiscosUseCase.output = [presenter]
        interactor.presenter = presenter
        presenter.view = viewController
        
        return viewController
    }
}
