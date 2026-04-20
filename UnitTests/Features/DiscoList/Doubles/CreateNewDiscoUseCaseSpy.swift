//
//  CreateNewDiscoUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class CreateNewDiscoUseCaseSpy: CreateNewDiscoUseCase {
    private var completion: ((Result<CreateNewDiscoUseCaseOutput, Error>) -> Void)?

    @SWSpyMethodTracker
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
