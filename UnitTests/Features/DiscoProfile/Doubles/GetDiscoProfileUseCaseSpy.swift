//
//  GetDiscoProfileUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class GetDiscoProfileUseCaseSpy: GetDiscoProfileUseCase {
    private var completion: ((Result<GetDiscoProfileUseCaseOutput, Error>) -> Void)?

    @SWSpyMethodTracker
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
