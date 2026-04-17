//
//  AuthorizationDecorator.swift
//  Main
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public protocol AuthorizationTokenProvider {
    func loadAuthorizationValue(
        completion: @escaping (Result<String, Error>) -> Void
    )

    func clearCachedTokenIfExists()
}

public final class AuthorizationDecorator: NetworkClient {
    let client: NetworkClient
    let tokenProvider: AuthorizationTokenProvider

    public init(client: NetworkClient, tokenProvider: AuthorizationTokenProvider) {
        self.client = client
        self.tokenProvider = tokenProvider
    }

    public func makeRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        tokenProvider.loadAuthorizationValue { [weak self] result in
            guard let self = self else { return }

            switch result {
            case.success(let authorizationValue):
                let decoratedEndpoint = applyAuthorizationHeader(
                    to: endpoint,
                    with: authorizationValue
                )
                self.client.makeRequest(decoratedEndpoint) { result in
                    switch result {
                    case.success(let data):
                        completion(.success(data))
                    case.failure(let error):
                        if let error = error as? NetworkError,
                            error == .httpError(401) {
                            self.tokenProvider.clearCachedTokenIfExists()
                            self.retryRequest(endpoint, completion: completion)
                            return
                        }
                        completion(.failure(error))
                    }
                }
            case.failure(let tokenError):
                completion(.failure(tokenError))
            }
        }
    }

    private func applyAuthorizationHeader(
        to endpoint: Endpoint,
        with authorizationValue: String
    ) -> Endpoint {
        var decoratedEndpoint = endpoint
        decoratedEndpoint.headers.updateValue(
            authorizationValue,
            forKey: "Authorization"
        )

        return decoratedEndpoint
    }

    private func retryRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        tokenProvider.loadAuthorizationValue { [weak self] result in
            guard let self = self else { return }

            switch result {
            case.success(let authorizationValue):
                let decoratedEndpoint = applyAuthorizationHeader(
                    to: endpoint,
                    with: authorizationValue
                )
                self.client.makeRequest(decoratedEndpoint, completion: completion)
            case.failure(let tokenError):
                completion(.failure(tokenError))
            }
        }
    }

}
