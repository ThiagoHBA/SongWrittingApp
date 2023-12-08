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
    let secureClient: SecureClient
    
    public init(networkClient: NetworkClient, secureClient: SecureClient) {
        self.networkClient = networkClient
        self.secureClient = secureClient
    }
    
    public func loadReferences(_ request: ReferenceRequest) {
        let enpoint = GetReferencesEndpoint(request: request)
        
        networkClient.makeRequest(enpoint) { result in
            switch result {
                case .success(let data):
                    print("Receiving data: \(data)")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
            }
        }
    }
}
