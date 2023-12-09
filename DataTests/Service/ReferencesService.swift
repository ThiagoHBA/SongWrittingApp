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
        sut.loadReferences("any request")
        XCTAssertEqual(network.makeRequestCalled, 1)
    }

}

extension ReferencesServiceTests {
    typealias SutAndDoubles = (
        sut: ReferencesServiceImpl,
        doubles: (NetworkClientSpy)
    )
    func makeSUT() -> SutAndDoubles {
        let networkSpy = NetworkClientSpy()
        let sut = ReferencesServiceImpl(
            networkClient: networkSpy
        )
        return (sut, (networkSpy))
    }
}
