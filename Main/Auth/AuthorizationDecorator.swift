//
//  AuthorizationDecorator.swift
//  Main
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
import Data
import Infra

class AuthorizationDecorator: NetworkClient {
    let client: NetworkClient
    let tokenProvider: AuthorizationHandler
    
    init(client: NetworkClient, tokenProvider: AuthorizationHandler) {
        self.client = client
        self.tokenProvider = tokenProvider
    }
    
    func makeRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        tokenProvider.loadToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let token):
                    let decoratedEndpoint = applyAuthorizationHeader(to: endpoint, with: token)
                    self.client.makeRequest(decoratedEndpoint) { result in
                        switch result {
                            case .success(let data):
                                completion(.success(data))
                            case .failure(let error):
                                if let error = error as? NetworkError,
                                    error == .httpError(401) {
                                    self.tokenProvider.clearCachedTokenIfExists()
                                    self.retryRequest(endpoint, completion: completion)
                                    return
                                }
                                completion(.failure(error))
                        }
                    }
                case .failure(let tokenError):
                    completion(.failure(tokenError))
            }
        }
    }
    
    private func applyAuthorizationHeader(
        to endpoint: Endpoint,
        with token: AccessTokenResponse
    ) -> Endpoint {
        let authorizationHeader = "\(token.tokenType) \(token.accessToken)"
        var decoratedEndpoint = endpoint
        decoratedEndpoint.headers.updateValue(
            authorizationHeader,
            forKey: "Authorization"
        )
        
        return decoratedEndpoint
    }
    
    private func retryRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        tokenProvider.loadToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let token):
                    let decoratedEndpoint = applyAuthorizationHeader(to: endpoint, with: token)
                    self.client.makeRequest(decoratedEndpoint, completion: completion)
                case .failure(let tokenError):
                    completion(.failure(tokenError))
            }
        }
    }
    
    
}
