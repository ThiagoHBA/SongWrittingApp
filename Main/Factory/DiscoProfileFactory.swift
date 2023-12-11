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
        let discoService = DiscoServiceFromMemory()
        
        let searchReferencesUseCase = SearchReferencesUseCase(service: referenceService)
        let getDiscoProfileUseCase = GetDiscoProfileUseCase(service: discoService)
        let addDiscoNewReferencesUseCase = AddDiscoNewReferenceUseCase(service: discoService)
        let addNewSectionUseCase = AddNewSectionToDiscoUseCase(service: discoService)
        
        let presenter = DiscoProfilePresenter()
        let interactor = DiscoProfileInteractor(
            searchReferencesUseCase: searchReferencesUseCase,
            getDiscoProfileUseCase: getDiscoProfileUseCase,
            addDiscoNewReferenceUseCase: addDiscoNewReferencesUseCase,
            addNewSectionToDiscoUseCase: addNewSectionUseCase
        )
        let viewController = DiscoProfileViewController(disco: data, interactor: interactor)
        
        searchReferencesUseCase.output = [presenter]
        getDiscoProfileUseCase.output = [presenter]
        addDiscoNewReferencesUseCase.output = [presenter]
        addNewSectionUseCase.output = [presenter]
        
        interactor.presenter = presenter
        presenter.view = WeakReferenceProxy(viewController)
    
        return viewController
    }
}

extension WeakReferenceProxy: DiscoProfileDisplayLogic where T: DiscoProfileDisplayLogic {
    func hideOverlays(completion: (() -> Void)?) {
        assert(self.instance != nil)
        self.instance?.hideOverlays(completion: completion)
    }
    
    func updateSections(_ sections: [SectionViewEntity]) {
        assert(self.instance != nil)
        self.instance?.updateSections(sections)
    }
    
    func addingSectionError(_ title: String, description: String) {
        assert(self.instance != nil)
        self.instance?.addingSectionError(title, description: description)
    }
    
    func updateReferences(_ references: [AlbumReferenceViewEntity]) {
        assert(self.instance != nil)
        self.instance?.updateReferences(references)
    }
    
    func showProfile(_ profile: DiscoProfileViewEntity) {
        assert(self.instance != nil)
        self.instance?.showProfile(profile)
    }
    
    func addingReferencesError(_ title: String, description: String) {
        assert(self.instance != nil)
        self.instance?.addingReferencesError(title, description: description)
    }
    
    func loadingProfileError(_ title: String, description: String) {
        assert(self.instance != nil)
        self.instance?.loadingProfileError(title, description: description)
    }
    
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
