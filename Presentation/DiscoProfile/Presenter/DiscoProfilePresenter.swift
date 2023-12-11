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
    
    public func presentReferences() {
        
    }
}

extension DiscoProfilePresenter: SearchReferencesUseCaseOutput {
    public func didFindedReferences(_ data: [AlbumReference]) {
        view?.hideLoading()
        view?.showReferences(data.map { AlbumReferenceViewEntity(from: $0) })
    }
    
    public func errorWhileFindingReferences(_ error: Error) {
        
    }
}
