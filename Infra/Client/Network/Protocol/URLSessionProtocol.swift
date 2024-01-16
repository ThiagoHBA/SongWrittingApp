//
//  URLSessionProtocol.swift
//  Infra
//
//  Created by Thiago Henrique on 26/12/23.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
