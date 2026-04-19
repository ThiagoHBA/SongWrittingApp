//
//  SearchReferencesUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class SearchReferencesUseCaseSpy: SearchReferencesUseCase {
    enum Message: Equatable {
        case search(SearchReferencesUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completion: ((Result<SearchReferencesUseCaseOutput, Error>) -> Void)?

    func search(
        _ input: SearchReferencesUseCaseInput,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.search(input))
        self.completion = completion
    }

    func completeSearch(with result: Result<SearchReferencesUseCaseOutput, Error>) {
        completion?(result)
    }
}
