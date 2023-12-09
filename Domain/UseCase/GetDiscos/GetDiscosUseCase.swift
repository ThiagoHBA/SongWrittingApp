//
//  GetDiscoProfile.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class GetDiscosUseCase: UseCase {
    let service: DiscoService
    public var output: GetDiscosUseCaseOutput?
    public var input: Any?
    
    public init(service: DiscoService) {
        self.service = service
    }
    
    public func execute() {

    }
}
