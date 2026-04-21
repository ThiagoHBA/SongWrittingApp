//
//  ReferenceSearchStrategyRegistryTests.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation
import XCTest
@testable import Main

final class ReferenceSearchStrategyRegistryTests: XCTestCase {
    func test_search_routes_to_selected_provider_and_loadMore_uses_active_strategy() {
        let spotify = SearchReferencesUseCaseSpy()
        let lastFM = SearchReferencesUseCaseSpy()
        let sut = ReferenceSearchStrategyRegistry(spotify: spotify, lastFM: lastFM)

        sut.search(.init(keywords: "any",  provider: .lastFM)) { _ in }
        sut.loadMore { _ in }

        XCTAssertEqual(spotify.receivedMessages, [])
        XCTAssertEqual(
            lastFM.receivedMessages,
            [
                .search(.init(keywords: "any",  provider: .lastFM)),
                .loadMore
            ]
        )
    }

    func test_reset_clears_all_strategies_and_active_search() {
        let spotify = SearchReferencesUseCaseSpy()
        let lastFM = SearchReferencesUseCaseSpy()
        let sut = ReferenceSearchStrategyRegistry(spotify: spotify, lastFM: lastFM)
        var receivedError: SearchReferencesUseCaseError?

        sut.search(.init(keywords: "any",  provider: .spotify)) { _ in }
        sut.reset()
        sut.loadMore { result in
            if case let .failure(error as SearchReferencesUseCaseError) = result {
                receivedError = error
            }
        }

        XCTAssertEqual(
            spotify.receivedMessages,
            [
                .search(.init(keywords: "any")),
                .reset
            ]
        )
        XCTAssertEqual(lastFM.receivedMessages, [.reset])
        XCTAssertEqual(receivedError, .noActiveSearchSession)
    }
}
