//
//  AddDiscoNewReferenceUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class AddDiscoNewReferenceUseCase {
    let service: DiscoService
    public var output: [AddDiscoNewReferenceUseCaseOutput]?
    public var input: AddDiscoNewReferenceInput?
    
    public init(service: DiscoService) {
        self.service = service
    }
    
    public func execute() {
        assert(input != nil)
        guard let input = input else { return }
        
        service.updateDiscoReferences(
            input.disco,
            references: input.newReferences
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let profile):
                    output?.forEach {
                        $0.successfullyAddNewReferences(
                            to: profile.disco,
                            references: profile.references
                        )
                    }
                case .failure(let error):
                    output?.forEach {
                        $0.errorWhileAddingNewReferences(error)
                    }
            }
            
        }
    }
}
