//
//  GetDiscoProfileUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class GetDiscoProfileUseCaseSpy: GetDiscoProfileUseCase {
    enum Message: Equatable {
        case load(GetDiscoProfileUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<GetDiscoProfileUseCaseOutput, Error>) -> Void)?

    func load(
        _ input: GetDiscoProfileUseCaseInput,
        completion: @escaping (Result<GetDiscoProfileUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.load(input))
        self.completion = completion
    }

    func completeLoad(with result: Result<GetDiscoProfileUseCaseOutput, Error>) {
        completion?(result)
    }
}
