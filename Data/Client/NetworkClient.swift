//
//  HTTPClient.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public protocol NetworkClient {
    func makeRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}
