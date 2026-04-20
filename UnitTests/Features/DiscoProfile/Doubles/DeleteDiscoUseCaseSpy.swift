//
//  DeleteDiscoUseCaseSpy.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class DeleteDiscoUseCaseSpy: DeleteDiscoUseCase {
    private var completions: [(Result<DiscoSummary, Error>) -> Void] = []

    @SWSpyMethodTracker
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
