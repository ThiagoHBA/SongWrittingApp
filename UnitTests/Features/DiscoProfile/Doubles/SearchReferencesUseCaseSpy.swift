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
        case loadMore
        case reset
    }

    private(set) var receivedMessages: [Message] = []
    private var searchCompletions: [(Result<SearchReferencesUseCaseOutput, Error>) -> Void] = []
    private var loadMoreCompletions: [(Result<SearchReferencesUseCaseOutput, Error>) -> Void] = []

    func search(
        _ input: SearchReferencesUseCaseInput,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.search(input))
        searchCompletions.append(completion)
    }

    func loadMore(
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.loadMore)
        loadMoreCompletions.append(completion)
    }

    func reset() {
        receivedMessages.append(.reset)
    }

    func completeSearch(
        with result: Result<SearchReferencesUseCaseOutput, Error>,
        at index: Int = 0
    ) {
        searchCompletions[index](result)
    }

    func completeLoadMore(
        with result: Result<SearchReferencesUseCaseOutput, Error>,
        at index: Int = 0
    ) {
        loadMoreCompletions[index](result)
    }
}
