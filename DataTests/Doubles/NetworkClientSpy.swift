//
//  NetworkClientSpy.swift
//  DataTests
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
@testable import Data

class NetworkClientSpy: NetworkClient {
    private(set) var makeRequestCalled = 0
    
    func makeRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        makeRequestCalled += 1
    }
}
