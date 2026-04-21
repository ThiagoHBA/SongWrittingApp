//
//  URLSessionDataTaskSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//


@testable import Main
import Foundation

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
