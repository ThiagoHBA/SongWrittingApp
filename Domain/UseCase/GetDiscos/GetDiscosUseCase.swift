//
//  GetDiscoProfile.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class GetDiscosUseCase: UseCase {
    let service: DiscoService
    public var output: [GetDiscosUseCaseOutput]?
    public var input: Any?

    public init(service: DiscoService) {
        self.service = service
    }

    public func execute() {
        service.loadDiscos { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let discoList):
                self.output?.forEach { $0.successfullyLoadDiscos(discoList) }
            case .failure(let error):
                self.output?.forEach { $0.errorWhileLoadingDiscos(error) }
            }
        }
    }
}
