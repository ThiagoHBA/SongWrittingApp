//
//  AddNewRecordToSessionUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class AddNewRecordToSessionUseCaseSpy: AddNewRecordToSessionUseCase {
    enum Message: Equatable {
        case addRecord(AddNewRecordToSessionUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<AddNewRecordToSessionUseCaseOutput, Error>) -> Void)?

    func addRecord(
        _ input: AddNewRecordToSessionUseCaseInput,
        completion: @escaping (Result<AddNewRecordToSessionUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.addRecord(input))
        self.completion = completion
    }

    func completeAddRecord(with result: Result<AddNewRecordToSessionUseCaseOutput, Error>) {
        completion?(result)
    }
}
