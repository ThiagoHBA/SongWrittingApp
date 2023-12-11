//
//  AddNewSectionToDiscoUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class AddNewSectionToDiscoUseCase: UseCase {
    let service: DiscoService
    public var input: AddNewSectionToDiscoUseCaseInput?
    public var output: [AddNewSectionToDiscoUseCaseOutput]?
    
    public init(service: DiscoService) {
        self.service = service
    }
    
    public func execute() {
        assert(input != nil)
        guard let input = input else { return }
        
        service.addNewSection(input.disco, input.section) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let profile):
                    output?.forEach { $0.successfullyAddedSectionToDisco(profile)}
                case .failure(let error):
                    output?.forEach { $0.errorWhileAddingSectionToDisco(error)}
            }
        }
    }
}

