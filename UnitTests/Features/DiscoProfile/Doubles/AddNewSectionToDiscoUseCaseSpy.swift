//
//  AddNewSectionToDiscoUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class AddNewSectionToDiscoUseCaseSpy: AddNewSectionToDiscoUseCase {
    enum Message: Equatable {
        case addSection(AddNewSectionToDiscoUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<AddNewSectionToDiscoUseCaseOutput, Error>) -> Void)?

    func addSection(
        _ input: AddNewSectionToDiscoUseCaseInput,
        completion: @escaping (Result<AddNewSectionToDiscoUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.addSection(input))
        self.completion = completion
    }

    func completeAddSection(with result: Result<AddNewSectionToDiscoUseCaseOutput, Error>) {
        completion?(result)
    }
}
