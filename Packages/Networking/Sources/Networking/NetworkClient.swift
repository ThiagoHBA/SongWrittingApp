//
//  HTTPClient.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public protocol Endpoint {
    var communicationProtocol: CommunicationProtocol { get }
    var urlBase: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod? { get }
    var body: Data? { get set }
    var headers: [String: String] { get set }
    var queries: [URLQueryItem] { get }
}

public enum CommunicationProtocol: String {
    case HTTP = "http"
    case HTTPS = "https"
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

public extension Endpoint {
    var httpMethod: HTTPMethod { return .get }

    var headers: [String: String] {
        let defaultHeaders = [
            "Content-Type": "application/json"
        ]
        return defaultHeaders
    }

    var queries: [URLQueryItem] { return [] }

    var body: Data? { return nil }

    func makeURL() -> URL? {
        guard var component = URLComponents(
            string: "\(communicationProtocol.rawValue)://\(urlBase)\(path)"
        ) else {
            return nil
        }
        component.scheme = communicationProtocol.rawValue
        component.queryItems = queries.isEmpty ? nil : queries
        return component.url
    }
}


public protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}


public protocol NetworkClient {
    func makeRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

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
