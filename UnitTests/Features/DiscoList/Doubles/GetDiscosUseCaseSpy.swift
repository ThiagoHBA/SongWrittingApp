//
//  GetDiscosUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class GetDiscosUseCaseSpy: GetDiscosUseCase {
    enum Message: Equatable {
        case load(GetDiscosUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<GetDiscosUseCaseOutput, Error>) -> Void)?

    func load(
        _ input: GetDiscosUseCaseInput,
        completion: @escaping (Result<GetDiscosUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.load(input))
        self.completion = completion
    }

    func completeLoad(with result: Result<GetDiscosUseCaseOutput, Error>) {
        completion?(result)
    }
}
