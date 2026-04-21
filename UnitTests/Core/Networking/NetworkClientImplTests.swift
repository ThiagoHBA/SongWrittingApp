//
//  NetworkClientImplTests.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import XCTest
@testable import Main

final class NetworkClientImplTests: XCTestCase {
    
    func test_makeRequest_requests_endpoint_url() {
        let (sut, session, _) = makeSUT()
        let endpoint = EndpointDummy()

        sut.makeRequest(endpoint) { _ in }

        let response = HTTPURLResponse(
            url: endpoint.makeURL()!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        session.dataTaskCompletion?(Data(), response, nil)

        XCTAssertEqual(session.requestedRequest?.url, endpoint.makeURL())
    }

    func test_makeRequest_cancels_previous_task_before_starting_new_one() {
        let (sut, session, firstTask) = makeSUT()
        let endpoint = EndpointDummy()

        sut.makeRequest(endpoint) { _ in }

        let secondTask = URLSessionDataTaskSpy()
        session.dataTask = secondTask

        sut.makeRequest(endpoint) { _ in }

        XCTAssertEqual(firstTask.cancelCalled, 1)
        XCTAssertEqual(secondTask.resumeCalled, 1)
    }

    func test_makeRequest_resumes_created_task() {
        let (sut, _, task) = makeSUT()

        sut.makeRequest(EndpointDummy()) { _ in }

        XCTAssertEqual(task.resumeCalled, 1)
    }

    private func makeSUT() -> (sut: NetworkClientImpl, session: URLSessionMock, task: URLSessionDataTaskSpy) {
        let session = URLSessionMock()
        let task = URLSessionDataTaskSpy()
        session.dataTask = task
        let sut = NetworkClientImpl(session: session)
        return (sut, session, task)
    }
}
