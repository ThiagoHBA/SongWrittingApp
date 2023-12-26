//
//  EndpointMock.swift
//  InfraTests
//
//  Created by Thiago Henrique on 26/12/23.
//

import Foundation
import Data

final class EndpointDummy: Endpoint {
    var headers: [String : String] = [:]
    var body: Data?
    
    var httpMethod: HTTPMethod? { .get }
    
    var communicationProtocol: CommunicationProtocol { .HTTPS }
    
    var urlBase: String { "www.google.com" }
    
    var path: String { "" }
}
