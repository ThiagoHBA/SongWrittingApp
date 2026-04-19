//
//  EndpointDummy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

@testable import Main
import Foundation

struct EndpointDummy: Endpoint {
    var communicationProtocol: CommunicationProtocol = .HTTPS
    var urlBase: String = "www.example.com"
    var path: String = "/resource"
    var httpMethod: HTTPMethod? = .get
    var body: Data?
    var headers: [String: String] = [:]
    var queries: [URLQueryItem] = []
}
