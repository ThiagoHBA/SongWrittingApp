//
//  DiscoListInteractor.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public final class DiscoListInteractor: DiscoListBusinessLogic {
    public var presenter: DiscoListPresentationLogic?
    public var router: DiscoListRouterLogic?
    
    let createNewDiscoUseCase: CreateNewDiscoUseCase
    let getDiscosUseCase: GetDiscosUseCase
    
    public init(
        getDiscosUseCase: GetDiscosUseCase,
        createNewDiscoUseCase: CreateNewDiscoUseCase
    ) {
        self.getDiscosUseCase = getDiscosUseCase
        self.createNewDiscoUseCase = createNewDiscoUseCase
    }
    
    public func loadDiscos() {
        presenter?.presentLoading()
        getDiscosUseCase.execute()
    }
    
    public func createDisco(name: String, image: Data) {
        if !discoIsValid(name, image) { return }

        presenter?.presentLoading()
        createNewDiscoUseCase.input = .init(name: name, image: image)
        createNewDiscoUseCase.execute()
    }
    
    public func showProfile(of disco: DiscoListViewEntity) {
        router?.showProfile(of: disco)
//        let profile = DiscoProfile(
//            disco: disco.mapToDomain(),
//            references: [],
//            section: []
//        )
    }
}

// MARK: - Validations
extension DiscoListInteractor {
    private func discoIsValid(_ name: String, _ image: Data) -> Bool {
        if name == "" {
            presenter?.presentCreateDiscoError(
                "Campos Vazios", 
                "O campo nome não pode ser vazio"
            )
            return false
        }
        
        if image == Data() {
            presenter?.presentCreateDiscoError(
                "Campos Vazios",
                "O Disco precisa de uma imagem"
            )
            return false
        }
        return true
    }
}

