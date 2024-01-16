//
//  URLSessionDataTaskDummy.swift
//  InfraTests
//
//  Created by Thiago Henrique on 26/12/23.
//

import Foundation
@testable import Infra

final class URLSessionDataTaskSpy: URLSessionDataTask {
    private(set) var resumeCalled = 0
    private(set) var cancelCalled = 0
    
    override func resume() {
        resumeCalled += 1
    }
    
    override func cancel() {
        cancelCalled += 1
    }
}
