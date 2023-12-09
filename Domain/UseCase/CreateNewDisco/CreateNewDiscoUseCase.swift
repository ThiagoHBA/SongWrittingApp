//
//  CreateNewDiscoUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class CreateNewDiscoUseCase: UseCase {
    var service: DiscoService
    var output: CreateNewDiscoUseCaseOutput?
    var input: CreateNewDiscoUseCaseInput?
    
    public init(service: DiscoService) {
        self.service = service
    }
    
    public func execute() {
        
    }
}
