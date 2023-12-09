//
//  CreateNewDiscoUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class CreateNewDiscoUseCase: UseCase {
    let service: DiscoService
    public var output: [CreateNewDiscoUseCaseOutput]?
    public var input: CreateNewDiscoUseCaseInput?
    
    public init(service: DiscoService) {
        self.service = service
    }
    
    public func execute() {
        assert(input != nil)
        guard let input = input else { return }

        service.createDisco(name: input.name, image: input.image) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let disco):
                    self.output?.forEach { $0.successfullyCreateDisco(disco)}
                case .failure(let error):
                    self.output?.forEach { $0.errorWhileCreatingDisco(error)}
            }
        }
    }
}
