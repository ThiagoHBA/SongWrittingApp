//
//  GetLastFMReferencesEndpoint.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation
import Networking

struct GetLastFMReferencesEndpoint: Endpoint {
    var headers: [String: String] = [:]
    var body: Data?
    var httpMethod: HTTPMethod? = .get
    var communicationProtocol: CommunicationProtocol = .HTTPS

    var urlBase: String {
        LastFMReferencesConstants.baseURL
    }

    var path: String {
        "/2.0/"
    }

    var queries: [URLQueryItem]

    init(
        keywords: String,
        limit: Int,
        page: Int
    ) {
        queries = [
            .init(name: "method", value: "album.search"),
            .init(name: "album", value: keywords),
            .init(name: "api_key", value: LastFMReferencesConstants.apiKey),
            .init(name: "format", value: "json"),
            .init(name: "limit", value: "\(limit)"),
            .init(name: "page", value: "\(page)")
        ]
    }
}
