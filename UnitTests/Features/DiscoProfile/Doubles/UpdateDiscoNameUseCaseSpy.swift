//
//  UpdateDiscoNameUseCaseSpy.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class UpdateDiscoNameUseCaseSpy: UpdateDiscoNameUseCase {
    private var completions: [(Result<DiscoSummary, Error>) -> Void] = []

    @SWSpyMethodTracker
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
