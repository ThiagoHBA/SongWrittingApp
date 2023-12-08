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
        let (sut, (network, _)) = makeSUT()
        let request = ReferenceRequest(keywords: "any request")
        sut.loadReferences(request)
        XCTAssertEqual(network.makeRequestCalled, 1)
    }

}

extension ReferencesServiceTests {
    typealias SutAndDoubles = (
        sut: ReferencesServiceImpl,
        doubles: (
            networkSpy: NetworkClientSpy,
            secureSpy: SecureClientSpy
        )
    )
    func makeSUT() -> SutAndDoubles {
        let networkSpy = NetworkClientSpy()
        let secureSpy = SecureClientSpy()
        let sut = ReferencesServiceImpl(
            networkClient: networkSpy,
            secureClient: secureSpy
        )
        return (sut, (networkSpy, secureSpy))
    }
}
