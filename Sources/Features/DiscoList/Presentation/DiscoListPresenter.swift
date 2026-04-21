//
//  DiscoListPresenter.swift
//  Main
//
//  Created by Thiago Henrique on 20/04/26.
//

import Foundation

protocol DiscoListPresentationLogic: AnyObject {
    func presentLoading()
    func presentLoadedDiscos(_ discos: [(disco: DiscoSummary, references: [AlbumReference])])
    func presentLoadDiscoError(_ error: Error)
    func presentCreatedDisco(_ disco: DiscoSummary)
    func presentCreateDiscoFailure(_ error: Error)
    func presentCreateDiscoError(_ error: Error)
    func presentDeletedDisco(_ disco: DiscoSummary)
    func presentDeleteDiscoError(_ error: Error)
}

final class DiscoListPresenter: DiscoListPresentationLogic {
    var view: DiscoListDisplayLogic?

    func presentLoading() {
        view?.startLoading()
    }

    func presentLoadedDiscos(_ discos: [(disco: DiscoSummary, references: [AlbumReference])]) {
        view?.hideLoading()
        view?.showDiscos(
            discos.map {
                DiscoListViewEntity(
                    from: $0.disco,
                    references: $0.references
                )
            })
    }

    func presentLoadDiscoError(_ error: Error) {
        view?.hideLoading()
        view?.loadDiscoError(
            DiscoListError.LoadDiscoError.errorTitle,
            error.localizedDescription
        )
    }

    func presentCreatedDisco(_ disco: DiscoSummary) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.showNewDisco(DiscoListViewEntity(from: disco))
        }
    }

    func presentCreateDiscoFailure(_ error: Error) {
        view?.hideLoading()
        view?.hideOverlays { [weak self] in
            self?.view?.createDiscoError(
                DiscoListError.CreateDiscoError.errorTitle,
                error.localizedDescription
            )
        }
    }

    func presentCreateDiscoError(_ error: Error) {
        view?.hideOverlays { [weak self] in
            self?.view?.createDiscoError(
                DiscoListError.CreateDiscoError.errorTitle,
                error.localizedDescription
            )
        }
    }

    func presentDeletedDisco(_ disco: DiscoSummary) {
        view?.removeDisco(DiscoListViewEntity(from: disco))
    }

    func presentDeleteDiscoError(_ error: Error) {
        view?.deleteDiscoError(
            DiscoListError.DeleteDiscoError.errorTitle,
            error.localizedDescription
        )
    }
}
