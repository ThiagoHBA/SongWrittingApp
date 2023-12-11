//
//  DiscoProfilePresenter.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public final class DiscoProfilePresenter: DiscoProfilePresentationLogic {
    public var view: DiscoProfileDisplayLogic?
    
    public init() {}

    public func presentLoading() {
        view?.startLoading()
    }
}

extension DiscoProfilePresenter: SearchReferencesUseCaseOutput {
    public func didFindedReferences(_ data: [AlbumReference]) {
        view?.hideLoading()
        view?.showReferences(data.map { AlbumReferenceViewEntity(from: $0) })
    }
    
    public func errorWhileFindingReferences(_ error: Error) {
        view?.hideLoading()
        view?.addingReferencesError("Erro!", description: error.localizedDescription)
    }
}

extension DiscoProfilePresenter: GetDiscoProfileUseCaseOutput {
    public func succesfullyLoadProfile(_ profile: DiscoProfile) {
        view?.hideLoading()
        view?.showProfile(DiscoProfileViewEntity(from: profile))
    }
    
    public func errorWhileLoadingProfile(_ error: Error) {
        view?.hideLoading()
        view?.loadingProfileError("Erro!", description: error.localizedDescription)
    }
}

extension DiscoProfilePresenter: AddDiscoNewReferenceUseCaseOutput {
    public func successfullyAddNewReferences(to disco:Disco, references: [AlbumReference]) {
        view?.hideLoading()
        view?.updateReferences(references.map { AlbumReferenceViewEntity(from: $0) })
    }
    
    public func errorWhileAddingNewReferences(_ error: Error) {
        view?.hideLoading()
        view?.addingReferencesError("Erro!", description: error.localizedDescription)
    }
}
