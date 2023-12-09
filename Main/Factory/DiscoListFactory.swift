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
        
        let presenter = DiscoListPresenter(
            getDiscosUseCase: getDiscosUseCase,
            createNewDiscoUseCase: createNewDiscoUseCase
        )
        let viewController = DiscoListViewController(presenter: presenter)
        
        // Memory Leaks
        createNewDiscoUseCase.output = [presenter]
        getDiscosUseCase.output = [presenter]
        presenter.view = viewController
        
        return viewController
    }
}
