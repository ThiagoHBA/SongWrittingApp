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
    
    func test_makeRequest_should_call_cancel_if_request_running() {
        let (sut, doubles) = makeSUT()
        let inputEndpoint = EndpointDummy()
        sut.makeRequest(inputEndpoint) { _ in }
        doubles.session.dataTaskCompletion?(Data(), HTTPURLResponse(), nil)
        sut.makeRequest(inputEndpoint) { _ in }
        XCTAssertEqual(doubles.dataTask.cancelCalled, 1)
    }
    
    func test_makeRequest_should_call_resume() {
        let (sut, doubles) = makeSUT()
        let inputEndpoint = EndpointDummy()
        sut.makeRequest(inputEndpoint) { _ in }
        doubles.session.dataTaskCompletion?(Data(), HTTPURLResponse(), nil)
        XCTAssertEqual(doubles.dataTask.resumeCalled, 1)
    }
}

extension NetworkClientTest {
    typealias SutAndDoubles = (
        sut: NetworkClientImpl,
        (
            session: URLSessionMock,
            dataTask: URLSessionDataTaskSpy
        )
    )
    func makeSUT() -> SutAndDoubles {
        let sessionMock = URLSessionMock()
        let dataTaskSpy = URLSessionDataTaskSpy()
        sessionMock.dataTask = dataTaskSpy
        let sut = NetworkClientImpl(session: sessionMock)
        return (sut, (sessionMock, dataTaskSpy))
    }
}
