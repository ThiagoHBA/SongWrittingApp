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
    public var presenter: DiscoProfilePresentationLogic?
    
    public init(searchReferencesUseCase: SearchReferencesUseCase) {
        self.searchReferencesUseCase = searchReferencesUseCase
    }
    
    public func searchNewReferences(keywords: String) {
        presenter?.presentLoading()
        searchReferencesUseCase.input = .init(keywords: keywords)
        searchReferencesUseCase.execute()
    }
    
    public func loadReferences(for disco: DiscoListViewEntity) {
        
    }
    public func loadProfile(for disco: DiscoListViewEntity) {
        
    }
}
