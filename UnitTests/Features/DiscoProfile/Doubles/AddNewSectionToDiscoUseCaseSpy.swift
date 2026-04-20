//
//  AddNewSectionToDiscoUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class AddNewSectionToDiscoUseCaseSpy: AddNewSectionToDiscoUseCase {
    private var completion: ((Result<AddNewSectionToDiscoUseCaseOutput, Error>) -> Void)?

    @SWSpyMethodTracker
    func addSection(
        _ input: AddNewSectionToDiscoUseCaseInput,
        completion: @escaping (Result<AddNewSectionToDiscoUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.addSection(input))
        self.completion = completion
    }

    func completeAddSection(with result: Result<AddNewSectionToDiscoUseCaseOutput, Error>) {
        completion?(result)
    }
}
