//
//  DiscoListPresenter.swift
//  Presentation
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation
import Domain

public final class DiscoListPresenter: DiscoListPresentationLogic {
    public var view: DiscoListDisplayLogic?
    
    public init() {}
    
    public func presentLoading() {
        view?.startLoading()
    }
    
    public func presentCreateDiscoError(_ error: DiscoListError.CreateDiscoError) {
        view?.hideOverlays { [weak self] in
            self?.view?.createDiscoError(
                DiscoListError.CreateDiscoError.errorTitle, 
                error.localizedDescription
            )
        }
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
            self?.view?.createDiscoError(
                DiscoListError.CreateDiscoError.errorTitle,
                error.localizedDescription
            )
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
        view?.loadDiscoError(
            DiscoListError.LoadDiscoError.errorTitle,
            error.localizedDescription
        )
    }
}


