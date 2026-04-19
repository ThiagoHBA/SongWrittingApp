//
//  URLSessionMock.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//


@testable import Main
import Foundation

final class URLSessionMock: URLSessionProtocol {
    var dataTask: URLSessionDataTaskSpy?
    private(set) var requestedRequest: URLRequest?
    var dataTaskCompletion: ((Data?, URLResponse?, Error?) -> Void)?

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        requestedRequest = request
        dataTaskCompletion = completionHandler
        return dataTask ?? URLSessionDataTaskSpy()
    }
}
