//
//  DiscoProfileInteractor.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public final class DiscoProfileInteractor: DiscoProfileBusinessRule {
    let searchReferencesUseCase: SearchReferencesUseCase
    let getDiscoProfileUseCase: GetDiscoProfileUseCase
    
    public var presenter: DiscoProfilePresentationLogic?
    
    public init(
        searchReferencesUseCase: SearchReferencesUseCase,
        getDiscoProfileUseCase: GetDiscoProfileUseCase
    ) {
        self.searchReferencesUseCase = searchReferencesUseCase
        self.getDiscoProfileUseCase = getDiscoProfileUseCase
    }
    
    public func searchNewReferences(keywords: String) {
        presenter?.presentLoading()
        searchReferencesUseCase.input = .init(keywords: keywords)
        searchReferencesUseCase.execute()
    }
    
    public func loadReferences(for disco: DiscoListViewEntity) {
        
    }
    public func loadProfile(for disco: DiscoListViewEntity) {
        presenter?.presentLoading()
        getDiscoProfileUseCase.input = .init(disco: disco.mapToDomain())
        getDiscoProfileUseCase.execute()
    }
}
