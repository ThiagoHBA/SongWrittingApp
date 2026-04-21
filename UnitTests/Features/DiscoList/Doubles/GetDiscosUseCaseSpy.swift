//
//  GetDiscosUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class GetDiscosUseCaseSpy: GetDiscosUseCase {
    private var completion: ((Result<GetDiscosUseCaseOutput, Error>) -> Void)?

    @SWSpyMethodTracker
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
