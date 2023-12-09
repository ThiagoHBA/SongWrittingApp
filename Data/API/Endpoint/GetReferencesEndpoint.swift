//
//  GetReferencesEndpoint.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
import Domain

struct GetReferencesEndpoint: Endpoint {
    var body: Data? = nil
    var httpMethod: HTTPMethod? = .get
    var communicationProtocol: CommunicationProtocol = .HTTPS
    var urlBase: String {
        return Constants.baseURL
    }
    var path: String {
        return "/v1/search/"
    }
    
    var headers: [String : String]
    var queries: [URLQueryItem]
    
    init(request: ReferenceRequest, headers: [String: String]) {
        self.queries = [.init(name: "q", value: request.keywords)]
        self.headers = headers
    }
}
