//
//  AddNewRecordToSession.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class AddNewRecordToSessionUseCase: UseCase {
    var input: AddNewRecordToSessionUseCaseInput?
    var output: [AddNewRecordToSessionUseCaseOutput]?
    let service: DiscoService
    
    public init(service: DiscoService) {
        self.service = service
    }
    
    public func execute() {
        
    }
}
