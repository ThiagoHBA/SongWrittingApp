//
//  CreateNewDiscoUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class CreateNewDiscoUseCaseSpy: CreateNewDiscoUseCase {
    enum Message: Equatable {
        case create(CreateNewDiscoUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<CreateNewDiscoUseCaseOutput, Error>) -> Void)?

    func create(
        _ input: CreateNewDiscoUseCaseInput,
        completion: @escaping (Result<CreateNewDiscoUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.create(input))
        self.completion = completion
    }

    func completeCreate(with result: Result<CreateNewDiscoUseCaseOutput, Error>) {
        completion?(result)
    }
}
