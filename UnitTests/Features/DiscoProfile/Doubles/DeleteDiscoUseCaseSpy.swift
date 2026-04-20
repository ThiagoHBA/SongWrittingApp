//
//  DeleteDiscoUseCaseSpy.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation
@testable import Main

final class DeleteDiscoUseCaseSpy: DeleteDiscoUseCase {
    enum Message: Equatable {
        case delete(DeleteDiscoUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completions: [(Result<DiscoSummary, Error>) -> Void] = []

    func delete(
        _ input: DeleteDiscoUseCaseInput,
        completion: @escaping (Result<DeleteDiscoUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.delete(input))
        completions.append(completion)
    }

    func completeDelete(with result: Result<DiscoSummary, Error>, at index: Int = 0) {
        completions[index](result)
    }
}
