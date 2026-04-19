//
//  AddDiscoNewReferenceUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class AddDiscoNewReferenceUseCaseSpy: AddDiscoNewReferenceUseCase {
    enum Message: Equatable {
        case addReferences(AddDiscoNewReferenceUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<AddDiscoNewReferenceUseCaseOutput, Error>) -> Void)?

    func addReferences(
        _ input: AddDiscoNewReferenceUseCaseInput,
        completion: @escaping (Result<AddDiscoNewReferenceUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.addReferences(input))
        self.completion = completion
    }

    func completeAddReferences(with result: Result<AddDiscoNewReferenceUseCaseOutput, Error>) {
        completion?(result)
    }
}
