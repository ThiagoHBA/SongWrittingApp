//
//  LoadReferencesUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public final class SearchReferencesUseCase {
    let service: ReferencesService
    let input: SearchReferencesUseCaseInput
    
    public init(service: ReferencesService, input: SearchReferencesUseCaseInput) {
        self.service = service
        self.input = input
    }
    
    public func execute() {
        service.loadReferences(input.keywords) { result in
//            switch result
        }
    }
}
