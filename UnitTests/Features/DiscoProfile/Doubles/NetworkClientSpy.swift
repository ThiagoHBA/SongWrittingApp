//
//  NetworkClientSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 20/04/26.
//


import Foundation
import Networking
import SongWrittingMacros
@testable import Main

final class NetworkClientSpy: NetworkClient {
    private(set) var makeRequestCalled = 0
    private(set) var receivedEndpointQueries: [URLQueryItem] = []
    private var completions: [(Result<Data, Error>) -> Void] = []
    var makeRequestCompletion: ((Result<Data, Error>) -> Void)? {
        completions.last
    }

    func makeRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        makeRequestCalled += 1
        receivedEndpointQueries = endpoint.queries
        completions.append(completion)
    }

    func completeRequest(at index: Int = 0, with result: Result<Data, Error>) {
        completions[index](result)
    }
}
