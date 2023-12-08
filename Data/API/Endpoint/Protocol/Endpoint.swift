//
//  EndpointProtocol.swift
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
    var headers: [String: String] { get }
    var queries: [URLQueryItem] { get }
}

public enum CommunicationProtocol: String {
    case HTTP = "http"
    case HTTPS = "https"
    case WS = "ws"
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
        guard var component = URLComponents(string: "\(communicationProtocol.rawValue)://\(urlBase)\(path)") else { return nil }
        component.scheme = communicationProtocol.rawValue
        component.queryItems = queries.isEmpty ? nil : queries
        return component.url
    }
}
