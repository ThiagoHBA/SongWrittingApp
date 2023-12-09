//
//  LoadReferencesUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public final class LoadReferencesUseCase {
    let service: ReferencesService
    let input: ReferenceRequest
    
    public init(service: ReferencesService, input: ReferenceRequest) {
        self.service = service
        self.input = input
    }
    
    public func execute() {
        service.loadReferences(input)
    }
}
