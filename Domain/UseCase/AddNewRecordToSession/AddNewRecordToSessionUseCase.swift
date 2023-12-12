//
//  AddNewRecordToSession.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public final class AddNewRecordToSessionUseCase: UseCase {
    public var input: AddNewRecordToSessionUseCaseInput?
    public var output: [AddNewRecordToSessionUseCaseOutput]?
    let service: DiscoService

    public init(service: DiscoService) {
        self.service = service
    }

    public func execute() {
        assert(input != nil)
        guard let input = input else { return }

        service.addNewRecord(
            input.disco,
            input.section
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let profile):
                output?.forEach { $0.successfullyAddedNewRecordToSection(profile) }
            case.failure(let error):
                output?.forEach { $0.errorWhileAddingNewRecordToSection(error) }
            }
        }
    }
}
