//
//  URLSessionMock.swift
//  InfraTests
//
//  Created by Thiago Henrique on 26/12/23.
//

import Foundation
@testable import Infra

final class URLSessionMock: URLSessionProtocol {
    var dataTask: URLSessionDataTaskDummy?
    
    // MARK: - CompletionHandler
    var dataTaskCompletion: ((Data?, URLResponse?, Error?) -> Void)?
    
    // MARK: - Observable variables
    private(set) var requestedData: URLRequest?
}

extension URLSessionMock {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        assert(dataTask != nil)
        requestedData = request
        dataTaskCompletion = completionHandler
        return dataTask!
    }
}
