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
    
    public var view: DiscoListDisplayLogic?
    
    public init(
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
        view?.hideOverlays { [weak self] in
            self?.view?.showNewDisco(DiscoListViewEntity(from: disco))
        }
    }
    
    public func errorWhileCreatingDisco(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.createDiscoError("Erro!", error.localizedDescription)
        }
    }
}

// MARK: - Get Discos Output
extension DiscoListPresenter: GetDiscosUseCaseOutput {
    public func successfullyLoadDiscos(_ discos: [Disco]) {
        view?.hideLoading()
        view?.showDiscos(discos.map { DiscoListViewEntity(from: $0) })
    }
    
    public func errorWhileLoadingDiscos(_ error: Error) {
        view?.hideLoading()
        view?.loadDiscoError("Erro!", error.localizedDescription)
    }
}

// MARK: - Validations
extension DiscoListPresenter {
    private func discoIsValid(_ name: String, _ image: Data) -> Bool {
        if name == "" {
            view?.hideOverlays { [weak self] in
                self?.view?.createDiscoError("Campos Vazios", "O campo nome não pode ser vazio")
            }
            return false
        }
        
        if image == Data() {
            view?.hideOverlays { [weak self] in
                self?.view?.createDiscoError("Compos Vazios", "O Disco precisa de uma imagem")
            }
            return false
        }
        return true
    }
}

