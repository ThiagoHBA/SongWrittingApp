//
//  NetworkClientImpl.swift
//  Infra
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
import Data

public final class NetworkClientImpl: NetworkClient {
    let session: URLSessionProtocol
    var task: URLSessionTask?

    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    public func makeRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = endpoint.makeURL() else {
            completion(.failure(NetworkError.unableToCreateURL))
            return
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        request.httpMethod = endpoint.httpMethod?.rawValue
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let response = response as? HTTPURLResponse else { return }
            let status = response.statusCode
            guard (200...299).contains(status) else {
                completion(.failure(NetworkError.httpError(status)))
                return
            }
            completion(.success(data))
        }
        task?.resume()
    }
}
