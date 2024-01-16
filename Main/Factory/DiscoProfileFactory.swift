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

        let referenceService = SpotifyReferencesService(networkClient: authDecorator)
        
        let discoStorage = InMemoryDiscoStorage(database: InMemoryDatabase.instance)
        let discoService = DiscoServiceImpl(storage: discoStorage)
        
        let searchReferencesUseCase = SearchReferencesUseCase(service: referenceService)
        let getDiscoProfileUseCase = GetDiscoProfileUseCase(service: discoService)
        let addDiscoNewReferencesUseCase = AddDiscoNewReferenceUseCase(service: discoService)
        let addNewSectionUseCase = AddNewSectionToDiscoUseCase(service: discoService)
        let addNewRecordToSectionUseCase = AddNewRecordToSessionUseCase(service: discoService)

        let presenter = DiscoProfilePresenter()
        let interactor = DiscoProfileInteractor(
            searchReferencesUseCase: searchReferencesUseCase,
            getDiscoProfileUseCase: getDiscoProfileUseCase,
            addDiscoNewReferenceUseCase: addDiscoNewReferencesUseCase,
            addNewSectionToDiscoUseCase: addNewSectionUseCase,
            addNewRecordToSessionUseCase: addNewRecordToSectionUseCase
        )
        let viewController = DiscoProfileViewController(disco: data, interactor: interactor)

        // MARK: - UseCase Outputs
        searchReferencesUseCase.output = [presenter]
        getDiscoProfileUseCase.output = [presenter]
        addDiscoNewReferencesUseCase.output = [presenter]
        addNewSectionUseCase.output = [presenter]
        addNewRecordToSectionUseCase.output = [presenter]

        // MARK: - Propety Composition
        interactor.presenter = presenter
        presenter.view = MainQueueProxy(WeakReferenceProxy(viewController))

        return viewController
    }
}

extension WeakReferenceProxy: DiscoProfileDisplayLogic where T: DiscoProfileDisplayLogic {
    func addingRecordsError(_ title: String, description: String) {
        assert(self.instance != nil)
        self.instance?.addingRecordsError(title, description: description)
    }

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

extension MainQueueProxy: DiscoProfileDisplayLogic where T: DiscoProfileDisplayLogic {
    func startLoading() {
        DispatchQueue.main.async {
            self.startLoading()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.hideLoading()
        }
    }
    
    func hideOverlays(completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.hideOverlays(completion: completion)
        }
    }
    
    func showReferences(_ references: [Presentation.AlbumReferenceViewEntity]) {
        DispatchQueue.main.async {
            self.showReferences(references)
        }
    }

    func showProfile(_ profile: Presentation.DiscoProfileViewEntity) {
        DispatchQueue.main.async {
            self.showProfile(profile)
        }
    }
    
    func updateReferences(_ references: [Presentation.AlbumReferenceViewEntity]) {
        DispatchQueue.main.async {
            self.updateReferences(references)
        }
    }
    
    func updateSections(_ sections: [Presentation.SectionViewEntity]) {
        DispatchQueue.main.async {
            self.updateSections(sections)
        }
    }
    
    func addingReferencesError(_ title: String, description: String) {
        DispatchQueue.main.async {
            self.addingReferencesError(title, description: description)
        }
    }
    
    func addingSectionError(_ title: String, description: String) {
        DispatchQueue.main.async {
            self.addingSectionError(title, description: description)
        }
    }
    
    func loadingProfileError(_ title: String, description: String) {
        DispatchQueue.main.async {
            self.loadingProfileError(title, description: description)
        }
    }
    
    func addingRecordsError(_ title: String, description: String) {
        DispatchQueue.main.async {
            self.addingRecordsError(title, description: description)
        }
    }
}
