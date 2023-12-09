//
//  ReferencesServiceImpl.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
import Domain

public class ReferencesServiceImpl: ReferencesService {
    let networkClient: NetworkClient
    
    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    public func loadReferences(_ request: ReferenceRequest) {
        let endpoint = GetReferencesEndpoint(request: request)
        
        networkClient.makeRequest(endpoint) { result in
            switch result {
            case .success(let data):
                print("Receiving data: \(data)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
