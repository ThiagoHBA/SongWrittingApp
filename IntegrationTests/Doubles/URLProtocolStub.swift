//
//  URLProtocolStub.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 21/04/26.
//

import Foundation
@testable import Main

final class URLProtocolStub: URLProtocol {
    private static var stub: (data: Data?, response: URLResponse?, error: Error?)?
    private(set) static var receivedRequest: URLRequest?

    static func stub(data: Data?, response: URLResponse?, error: Error?) {
        self.stub = (data, response, error)
    }

    static func reset() {
        stub = nil
        receivedRequest = nil
    }

    override class func canInit(with request: URLRequest) -> Bool {
        receivedRequest = request
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let error = Self.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        if let response = Self.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = Self.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension URL {
    var queryItems: [URLQueryItem]? {
        URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems
    }
}
