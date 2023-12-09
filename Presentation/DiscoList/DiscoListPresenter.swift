//
//  DiscoListPresenter.swift
//  Presentation
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation
import Domain

public final class DiscoListPresenter: DiscoListPresentationLogic {
    let createNewDiscoUseCase: CreateNewDiscoUseCase
    let getDiscosUseCase: GetDiscosUseCase
    
    var view: DiscoListDisplayLogic?
    
    init(
        getDiscosUseCase: GetDiscosUseCase,
        createNewDiscoUseCase: CreateNewDiscoUseCase
    ) {
        self.getDiscosUseCase = getDiscosUseCase
        self.createNewDiscoUseCase = createNewDiscoUseCase
    }
    
    public func loadDiscos() {
        view?.startLoading()
        getDiscosUseCase.execute()
    }
    
    public func createDisco(name: String, image: Data) {
        if !discoIsValid(name, image) { return }
        
        view?.startLoading()
        createNewDiscoUseCase.input = .init(name: name, image: image)
        createNewDiscoUseCase.execute()
    }
}

// MARK: - Create Disco Output
extension DiscoListPresenter: CreateNewDiscoUseCaseOutput {
    public func successfullyCreateDisco(_ disco: Disco) {
        view?.hideLoading()
        view?.showNewDisco(disco)
    }
    
    public func errorWhileCreatingDisco(_ error: Error) {
        view?.hideLoading()
        view?.showError("Erro!", error.localizedDescription)
    }
}

// MARK: - Get Discos Output
extension DiscoListPresenter: GetDiscosUseCaseOutput {
    public func successfullyLoadDiscos(_ discos: [Disco]) {
        view?.hideLoading()
        view?.showDiscos(discos)
    }
    
    public func errorWhileLoadingDiscos(_ error: Error) {
        view?.hideLoading()
        view?.showError("Erro!", error.localizedDescription)
    }
}

// MARK: - Validations
extension DiscoListPresenter {
    private func discoIsValid(_ name: String, _ image: Data) -> Bool {
        if name == "" {
            view?.showError("Campos Vazios", "O campo nome não pode ser vazio")
            return false
        }
        
        if image == Data() {
            view?.showError("Compos Vazios", "O Disco precisa de uma imagem")
            return false
        }
        return true
    }
}

