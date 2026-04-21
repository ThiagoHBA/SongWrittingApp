//
//  SecureClientImplTests.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import Security
import XCTest
@testable import Main

final class SecureClientImplTests: XCTestCase {
    func test_saveData_requests_add_with_server() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)

        try? sut.saveData(Data("payload".utf8))

        let query = keychain.addedQuery as? [String: Any]

        XCTAssertEqual(query?[kSecAttrServer as String] as? String, identifier)
    }

    func test_saveData_requests_add_with_data() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        let expectedData = Data("payload".utf8)

        try? sut.saveData(expectedData)

        let query = keychain.addedQuery as? [String: Any]

        XCTAssertEqual(query?[kSecValueData as String] as? Data, expectedData)
    }
    

    func test_saveData_throws_unhandledError_when_add_fails() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        keychain.addStatus = errSecDuplicateItem

        let receivedError = captureError {
            try sut.saveData(Data("payload".utf8))
        }

        XCTAssertEqual(
            receivedError as? SecurePersistenceError,
            .unhandledError(status: errSecDuplicateItem)
        )
    }

    func test_getData_requests_copyMatching_with_server() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        keychain.copiedItem = [kSecValueData as String: Data("payload".utf8)] as CFDictionary

        _ = try? sut.getData()

        let query = keychain.copiedQuery as? [String: Any]

        XCTAssertEqual(query?[kSecAttrServer as String] as? String, identifier)
    }

    func test_getData_requests_copyMatching_with_match_limit_one() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        keychain.copiedItem = [kSecValueData as String: Data("payload".utf8)] as CFDictionary

        _ = try? sut.getData()

        let query = keychain.copiedQuery as? [String: Any]

        XCTAssertEqual(query?[kSecMatchLimit as String] as? String, kSecMatchLimitOne as String)
    }

    func test_getData_requests_copyMatching_returning_attributes() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        keychain.copiedItem = [kSecValueData as String: Data("payload".utf8)] as CFDictionary

        _ = try? sut.getData()

        let query = keychain.copiedQuery as? [String: Any]

        XCTAssertEqual(query?[kSecReturnAttributes as String] as? Bool, true)
    }

    func test_getData_requests_copyMatching_returning_data() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        keychain.copiedItem = [kSecValueData as String: Data("payload".utf8)] as CFDictionary

        _ = try? sut.getData()

        let query = keychain.copiedQuery as? [String: Any]

        XCTAssertEqual(query?[kSecReturnData as String] as? Bool, true)
    }

    func test_getData_returns_data_when_copyMatching_succeeds() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        let expectedData = Data("payload".utf8)
        keychain.copiedItem = [kSecValueData as String: expectedData] as CFDictionary

        let receivedData = try? sut.getData()

        XCTAssertEqual(receivedData, expectedData)
    }

    func test_getData_throws_noData_when_item_is_not_found() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        keychain.copyMatchingStatus = errSecItemNotFound

        let receivedError = captureError {
            _ = try sut.getData()
        }

        XCTAssertEqual(receivedError as? SecurePersistenceError, .noData)
    }

    func test_getData_throws_unhandledError_when_copyMatching_fails() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        keychain.copyMatchingStatus = errSecAuthFailed

        let receivedError = captureError {
            _ = try sut.getData()
        }

        XCTAssertEqual(
            receivedError as? SecurePersistenceError,
            .unhandledError(status: errSecAuthFailed)
        )
    }

    func test_getData_throws_unhandledError_when_returned_item_does_not_contain_data() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        keychain.copiedItem = [kSecAttrServer as String: "server.test"] as CFDictionary

        let receivedError = captureError {
            _ = try sut.getData()
        }

        XCTAssertEqual(
            receivedError as? SecurePersistenceError,
            .unhandledError(status: errSecSuccess)
        )
    }

    func test_deleteData_requests_delete_with_server() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)

        try? sut.deleteData()

        let query = keychain.deletedQuery as? [String: Any]

        XCTAssertEqual(query?[kSecAttrServer as String] as? String, "server.test")
    }

    func test_deleteData_does_not_throw_when_delete_succeeds() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)

        let receivedError = captureError {
            try sut.deleteData()
        }

        XCTAssertNil(receivedError)
    }

    func test_deleteData_does_not_throw_when_item_is_not_found() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        keychain.deleteStatus = errSecItemNotFound

        let receivedError = captureError {
            try sut.deleteData()
        }

        XCTAssertNil(receivedError)
    }

    func test_deleteData_throws_unhandledError_when_delete_fails() {
        let identifier = "server.test"
        let (sut, keychain) = makeSUT(serverIdentifier: identifier)
        keychain.deleteStatus = errSecInteractionNotAllowed

        let receivedError = captureError {
            try sut.deleteData()
        }

        XCTAssertEqual(
            receivedError as? SecurePersistenceError,
            .unhandledError(status: errSecInteractionNotAllowed)
        )
    }
}

extension SecureClientImplTests {
    typealias SutAndDoubles = (
        sut: SecureClientImpl,
        keychain: KeychainClientMock
    )
    
    func makeSUT(serverIdentifier: String) -> SutAndDoubles {
        let keychain = KeychainClientMock()
        let sut = SecureClientImpl(server: serverIdentifier, keychain: keychain)
        return (sut, keychain)
    }
}

extension SecureClientImplTests {
    private func captureError(_ action: () throws -> Void) -> Error? {
        do {
            try action()
            return nil
        } catch {
            return error
        }
    }
}
