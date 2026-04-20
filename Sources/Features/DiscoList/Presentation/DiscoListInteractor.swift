//
//  DiscoListInteractor.swift
//  Main
//
//  Created by Thiago Henrique on 20/04/26.
//

import Foundation

protocol DiscoListBusinessLogic: AnyObject {
    func loadDiscos()
    func createDisco(name: String, description: String?, image: Data)
    func showProfile(of disco: DiscoListViewEntity)
    func deleteDisco(_ disco: DiscoListViewEntity)
}

final class DiscoListInteractor: DiscoListBusinessLogic {
    var presenter: DiscoListPresentationLogic?
    var router: DiscoListRouting?

    private let createNewDiscoUseCase: CreateNewDiscoUseCase
    private let getDiscosUseCase: GetDiscosUseCase
    private let deleteDiscoUseCase: DeleteDiscoUseCase

    init(
        getDiscosUseCase: GetDiscosUseCase,
        createNewDiscoUseCase: CreateNewDiscoUseCase,
        deleteDiscoUseCase: DeleteDiscoUseCase
    ) {
        self.getDiscosUseCase = getDiscosUseCase
        self.createNewDiscoUseCase = createNewDiscoUseCase
        self.deleteDiscoUseCase = deleteDiscoUseCase
    }

    func loadDiscos() {
        presenter?.presentLoading()
        getDiscosUseCase.load(.init()) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let discos):
                self.presenter?.presentLoadedDiscos(discos)
            case .failure(let error):
                self.presenter?.presentLoadDiscoError(error)
            }
        }
    }

    func createDisco(name: String, description: String?, image: Data) {
        presenter?.presentLoading()

        do {
            let disco = try Disco(name: name, description: description, image: image)

            createNewDiscoUseCase.create(disco) { [weak self] result in
                guard let self else { return }

                switch result {
                case .success(let disco):
                    self.presenter?.presentCreatedDisco(disco)
                case .failure(let error):
                    self.presenter?.presentCreateDiscoFailure(error)
                }
            }
        } catch {
            presenter?.presentCreateDiscoError(error)
        }
    }

    func showProfile(of disco: DiscoListViewEntity) {
        router?.showProfile(of: disco.toSummary())
    }

    func deleteDisco(_ disco: DiscoListViewEntity) {
        deleteDiscoUseCase.delete(.init(disco: disco.toSummary())) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let deleted):
                self.presenter?.presentDeletedDisco(deleted)
            case .failure(let error):
                self.presenter?.presentDeleteDiscoError(error)
            }
        }
    }
}
