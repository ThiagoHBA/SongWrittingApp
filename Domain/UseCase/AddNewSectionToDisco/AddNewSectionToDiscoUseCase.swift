//
//  AddNewSectionToDiscoUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class AddNewSectionToDiscoUseCase: UseCase {
    let service: DiscoService
    public var input: AddDiscoNewReferenceInput?
    public var output: AddDiscoNewReferenceUseCaseOutput?
    
    init(service: DiscoService) {
        self.service = service
    }
    
    func execute() {
        
    }
}

