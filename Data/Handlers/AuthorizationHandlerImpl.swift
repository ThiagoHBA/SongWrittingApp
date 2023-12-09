//
//  AuthorizationHandler.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public final class AuthorizationHandlerImpl: AuthorizationHandler {
    let networkClient: NetworkClient
    let secureClient: SecurePersistenceClient
    
    public init(networkClient: NetworkClient, secureClient: SecurePersistenceClient) {
        self.networkClient = networkClient
        self.secureClient = secureClient
    }
    
    public func loadToken (
        completion: @escaping (Result<AccessTokenResponse,TokenError>) -> Void
    ) {
        if let cachedToken = getCachedToken() {
            completion(.success(cachedToken))
            return
        }
        
        let authString = "\(Constants.clientID):\(Constants.clientSecret)"
        guard let authBytes = authString.data(using: .utf8) else {
            completion(.failure(.unableToCreateToken))
            return
        }
        let authBase64 = authBytes.base64EncodedString()
        let endpoint = LoadTokenEndpoint(
            headers: [
                "Authorization": "Basic \(authBase64)",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        )
        
        networkClient.makeRequest(endpoint) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let data):
                    do {
                        try self.secureClient.saveData(data)
                        let token = try AccessTokenResponse.loadFromData(data)
                        completion(.success(token))
                    } catch {
                        completion(.failure(.unableToCreateToken))
                    }
                case .failure(let error):
                    completion(.failure(.requestError(error)))
            }
        }
    }
    
    private func getCachedToken() -> AccessTokenResponse? {
        guard let tokenData = try? secureClient.getData() else { return nil }
        do {
            let token = try AccessTokenResponse.loadFromData(tokenData)
            return token
        } catch {
            return nil
        }
    }
}
