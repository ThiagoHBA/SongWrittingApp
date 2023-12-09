//
//  LoadReferencesUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public final class LoadReferencesUseCase {
    let service: ReferencesService
    let input: LoadReferencesUseCaseInput
    
    public init(service: ReferencesService, input: LoadReferencesUseCaseInput) {
        self.service = service
        self.input = input
    }
    
    public func execute() {
        service.loadReferences(input.keywords)
    }
}
