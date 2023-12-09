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
    let secureClient: SecurePersistenceClient
    
    public init(networkClient: NetworkClient, secureClient: SecurePersistenceClient) {
        self.networkClient = networkClient
        self.secureClient = secureClient
    }
    
    public func loadReferences(_ request: ReferenceRequest) {
        do {
            let tokenData = try secureClient.getData()
            let token = try JSONDecoder().decode(AccessTokenResponse.self, from: tokenData)
            
            let enpoint = GetReferencesEndpoint(
                request: request,
                headers: [
                    "Authorization": "\(token.tokenType) \(token.accessToken)"
                ]
            )
            
            networkClient.makeRequest(enpoint) { result in
                switch result {
                case .success(let data):
                    print("Receiving data: \(data)")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
