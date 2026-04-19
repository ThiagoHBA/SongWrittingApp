//
//  InMemoryDatabaseTests.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import XCTest
@testable import Main

final class InMemoryDatabaseTests: XCTestCase {
    func test_init_starts_with_empty_discos() {
        let sut = makeSUT()

        XCTAssertTrue(sut.discos.isEmpty)
    }

    func test_init_starts_with_empty_profiles() {
        let sut = makeSUT()

        XCTAssertTrue(sut.profiles.isEmpty)
    }

    private func makeSUT() -> InMemoryDatabase {
        InMemoryDatabase()
    }
}
