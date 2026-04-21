//
//  AddNewRecordToSessionUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class AddNewRecordToSessionUseCaseSpy: AddNewRecordToSessionUseCase {
    private var completion: ((Result<AddNewRecordToSessionUseCaseOutput, Error>) -> Void)?

    @SWSpyMethodTracker
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
