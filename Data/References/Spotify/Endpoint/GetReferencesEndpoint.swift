//
//  GetReferencesEndpoint.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
import Domain

struct GetReferencesEndpoint: Endpoint {
    var headers: [String: String]
    var body: Data?
    var httpMethod: HTTPMethod? = .get
    var communicationProtocol: CommunicationProtocol = .HTTPS
    var urlBase: String {
        return SpotifyReferencesConstants.baseURL
    }
    var path: String {
        return "/v1/search/"
    }
    var queries: [URLQueryItem]

    init(keywords: String, headers: [String: String] = [:]) {
        self.queries = [
            .init(name: "q", value: keywords),
            .init(name: "type", value: "album")
        ]
        self.headers = headers
    }
}
