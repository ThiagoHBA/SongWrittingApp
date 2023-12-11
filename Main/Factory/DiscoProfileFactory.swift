//
//  DiscoProfileFactory.swift
//  Main
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Infra
import Data
import Domain
import Presentation
import UI

struct DiscoProfileFactory {
    static func make(with data: DiscoListViewEntity) -> DiscoProfileViewController {
        let networkClient = NetworkClientImpl()
        let secureClient = SecureClientImpl()
        let authHandler = AuthorizationHandlerImpl(
            networkClient: networkClient,
            secureClient: secureClient
        )
        let authDecorator = AuthorizationDecorator(
            client: networkClient,
            tokenProvider: authHandler
        )

        let referenceService = ReferencesServiceImpl(networkClient: authDecorator)
        let searchReferencesUseCase = SearchReferencesUseCase(service: referenceService)
        
        let presenter = DiscoProfilePresenter()
        let interactor = DiscoProfileInteractor(
            searchReferencesUseCase: searchReferencesUseCase
        )
        let viewController = DiscoProfileViewController(
            disco: data,
            interactor: interactor
        )
        
        searchReferencesUseCase.output = [presenter]
        interactor.presenter = presenter
        presenter.view = WeakReferenceProxy(viewController)
    
        return viewController
    }
}

extension WeakReferenceProxy: DiscoProfileDisplayLogic where T: DiscoProfileDisplayLogic {
    func startLoading() {
        assert(self.instance != nil)
        self.instance?.startLoading()
    }
    
    func hideLoading() {
        assert(self.instance != nil)
        self.instance?.hideLoading()
    }
    
    func showReferences(_ references: [AlbumReferenceViewEntity]) {
        assert(self.instance != nil)
        self.instance?.showReferences(references)
    }
}
