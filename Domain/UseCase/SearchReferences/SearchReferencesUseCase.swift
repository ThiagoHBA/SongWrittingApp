//
//  LoadReferencesUseCase.swift
//  Domain
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public final class SearchReferencesUseCase {
    let service: ReferencesService
    public var input: SearchReferencesUseCaseInput?
    public var output: [SearchReferencesUseCaseOutput]?
    
    public init(service: ReferencesService) {
        self.service = service
    }
    
    public func execute() {
        assert(input != nil)
        guard let input = input else { return }
        
        service.loadReferences(input.keywords) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    output?.forEach { $0.didFindedReferences(data) }
                case .failure(let error):
                    output?.forEach { $0.errorWhileFindingReferences(error) }
            }
        }
    }
}
