//
//  AuthorizationDecorator.swift
//  Main
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
import Data

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
                    let authorizationHeader = "\(token.tokenType) \(token.accessToken)"
                    var decoratedEndpoint = endpoint
                    decoratedEndpoint.headers.updateValue(authorizationHeader, forKey: "Authorization")
                    self.client.makeRequest(decoratedEndpoint, completion: completion)
                case .failure(let tokenError):
                    break
//                guard let case TokenError.
            }
        }
    }
    
    
}
