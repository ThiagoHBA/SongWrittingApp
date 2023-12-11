//
//  GetDiscoProfileUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class GetDiscoProfileUseCase: UseCase {
    let service: DiscoService
    var input: GetDiscoProfileUseCaseInput?
    var output: [GetDiscoProfileUseCaseOutput]?
    
    public init(service: DiscoService) {
        self.service = service
    }
    
    public func execute() {
        assert(input != nil)
        guard let input = input else { return }
        
        service.loadProfile(for: input.disco) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let profile):
                    output?.forEach { $0.succesfullyLoadProfile(profile) }
                case .failure(let error):
                    output?.forEach { $0.errorWhileLoadingProfile(error) }
            }
        }
    }
}
