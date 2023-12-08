//
//  LoadTokenEndpoint.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

struct LoadTokenEndpoint: Endpoint {
    var body: Data? = nil
    var httpMethod: HTTPMethod? = .post
    var communicationProtocol: CommunicationProtocol = .HTTPS
    var headers: [String : String]
    
    var urlBase: String {
        return Constants.accountUrl
    }
    
    var path: String {
        return "/api/token"
    }
    
    init(headers: [String: String]) {
        self.headers = headers
    }
}
