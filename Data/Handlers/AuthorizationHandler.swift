//
//  AuthorizationHandler.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public final class AuthorizationHandler {
    let networkClient: NetworkClient
    let secureClient: SecurePersistenceClient
    
    public init(networkClient: NetworkClient, secureClient: SecurePersistenceClient) {
        self.networkClient = networkClient
        self.secureClient = secureClient
    }
    
    public func loadToken(
        completion: @escaping (Result<AccessTokenResponse, Error>) -> Void
    ) {
        let authString = "\(Constants.clientID):\(Constants.clientSecret)"
        guard let authBytes = authString.data(using: .utf8) else {
            completion(.failure(DataError.unableToCreateToken))
            return
        }
        let authBase64 = authBytes.base64EncodedString()
        let endpoint = LoadTokenEndpoint(
            headers: [
                "Authorization": "Basic \(authBase64)",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        )
        
        networkClient.makeRequest(endpoint) { result in
            switch result {
                case .success(let data):
                    do {
                        let token = try AccessTokenResponse.loadFromData(data)
                        completion(.success(token))
                    } catch {
                        completion(.failure(DataError.decodingError))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
