//
//  SearchReferencesUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class SearchReferencesUseCaseSpy: SearchReferencesUseCase {
    private var searchCompletions: [(Result<SearchReferencesUseCaseOutput, Error>) -> Void] = []
    private var loadMoreCompletions: [(Result<SearchReferencesUseCaseOutput, Error>) -> Void] = []

    @SWSpyMethodTracker
    func search(
        _ input: SearchReferencesUseCaseInput,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.search(input))
        searchCompletions.append(completion)
    }

    @SWSpyMethodTracker
    func loadMore(
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.loadMore)
        loadMoreCompletions.append(completion)
    }

    func reset() {  }

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
