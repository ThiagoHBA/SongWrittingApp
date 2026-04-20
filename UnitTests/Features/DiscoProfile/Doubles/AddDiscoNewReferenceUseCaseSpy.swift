//
//  AddDiscoNewReferenceUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class AddDiscoNewReferenceUseCaseSpy: AddDiscoNewReferenceUseCase {
    private var completion: ((Result<AddDiscoNewReferenceUseCaseOutput, Error>) -> Void)?

    @SWSpyMethodTracker
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
