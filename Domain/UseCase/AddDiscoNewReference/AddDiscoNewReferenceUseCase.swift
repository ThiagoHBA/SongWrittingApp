//
//  AddDiscoNewReferenceUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class AddDiscoNewReferenceUseCase {
    let service: DiscoService
    public var output: AddDiscoNewReferenceUseCaseOutput?
    public var input: AddDiscoNewReferenceInput?
    
    init(service: DiscoService) {
        self.service = service
    }
    
    func execute() {
        assert(input != nil)
        guard let input = input else { return }
        
        
    }
}
