//
//  DataTests.swift
//  DataTests
//
//  Created by Thiago Henrique on 08/12/23.
//

import XCTest
@testable import Domain
@testable import Data

final class ReferencesServiceTests: XCTestCase {

    func test_loadReferences_should_call_network_client() {
        let (sut, (network)) = makeSUT()
        let expectation = XCTestExpectation(description: "Completion Called")
        guard let inputData = try? JSONEncoder().encode(
            AlbumReferenceDataEntity(albums: .init(items: []))
        ) else { return }

        sut.loadReferences("any request") { result in
            switch result {
            case.success: break
            case.failure(let error):
                XCTFail("Tests should not raise error, but: \(error)")
            }
            expectation.fulfill()
        }
        network.makeRequestCompletion?(.success(inputData))
        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(network.makeRequestCalled, 1)
    }

    func test_loadReferences_if_invalid_data_should_throw_decode_error() {
        let (sut, (network)) = makeSUT()
        let expectation = XCTestExpectation(description: "Completion Called")
        let inputData = Data()

        sut.loadReferences("any request") { result in
            switch result {
            case.success(let data):
                XCTFail("sut should not succeded, but: \(data)")
            case.failure(let error):
                XCTAssertNotNil(error as? DataError)
            }
            expectation.fulfill()
        }
        network.makeRequestCompletion?(.success(inputData))
        wait(for: [expectation], timeout: 1)
    }

    func test_loadReferences_if_network_error_should_call_completion_correctly() {
        let (sut, (network)) = makeSUT()
        let expectation = XCTestExpectation(description: "Clousure Error")

        sut.loadReferences("any request") { result in
            switch result {
            case.success(let data):
                XCTFail("sut should not succeded, but: \(data)")
            case.failure:
                expectation.fulfill()
            }
        }
        network.makeRequestCompletion?(.failure(NSError(domain: "any", code: 0)))
        wait(for: [expectation], timeout: 1)
    }

}

extension ReferencesServiceTests {
    typealias SutAndDoubles = (
        sut: SpotifyReferencesService,
        doubles: (NetworkClientSpy)
    )
    func makeSUT() -> SutAndDoubles {
        let networkSpy = NetworkClientSpy()
        let sut = SpotifyReferencesService(
            networkClient: networkSpy
        )
        return (sut, (networkSpy))
    }
}
