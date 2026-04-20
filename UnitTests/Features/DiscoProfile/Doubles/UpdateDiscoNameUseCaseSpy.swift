//
//  UpdateDiscoNameUseCaseSpy.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation
@testable import Main

final class UpdateDiscoNameUseCaseSpy: UpdateDiscoNameUseCase {
    enum Message: Equatable {
        case updateName(UpdateDiscoNameInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completions: [(Result<DiscoSummary, Error>) -> Void] = []

    func updateName(
        _ input: UpdateDiscoNameUseCaseInput,
        completion: @escaping (Result<UpdateDiscoNameUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.updateName(input))
        completions.append(completion)
    }

    func completeUpdate(with result: Result<DiscoSummary, Error>, at index: Int = 0) {
        completions[index](result)
    }
}
