//
//  NetworkClientTest.swift
//  InfraTests
//
//  Created by Thiago Henrique on 26/12/23.
//

import XCTest
@testable import Infra

final class NetworkClientTest: XCTestCase {
    func test_makeRequest_url_should_being_requested() {
        let (sut, doubles) = makeSUT()
        let inputEndpoint = EndpointDummy()
        let expectation = XCTestExpectation(description: "Uses the same URL to request")
        
        sut.makeRequest(inputEndpoint) { result in
            switch result {
            case .success(_):
                XCTAssertEqual(doubles.session.requestedData?.url, inputEndpoint.makeURL())
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Shouldnt raise error, but: \(error.localizedDescription)")
            }
        }
        doubles.session.dataTaskCompletion?(Data(), HTTPURLResponse(), nil)
        wait(for: [expectation], timeout: 1)
    }
}

extension NetworkClientTest {
    typealias SutAndDoubles = (
        sut: NetworkClientImpl,
        (
            session: URLSessionMock,
            dataTask: URLSessionDataTaskDummy
        )
    )
    func makeSUT() -> SutAndDoubles {
        let sessionMock = URLSessionMock()
        let dataTaskMock = URLSessionDataTaskDummy()
        sessionMock.dataTask = dataTaskMock
        let sut = NetworkClientImpl(session: sessionMock)
        return (sut, (sessionMock, dataTaskMock))
    }
}
