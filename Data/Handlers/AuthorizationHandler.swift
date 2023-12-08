//
//  AuthorizationHandler.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public final class AuthorizationHandler {
    let networkClient: NetworkClient
    let secureClient: SecureClient
    
    public init(networkClient: NetworkClient, secureClient: SecureClient) {
        self.networkClient = networkClient
        self.secureClient = secureClient
    }
    
    public func loadToken() {
        let authString = "\(Constants.clientID):\(Constants.clientSecret)"
        guard let authBytes = authString.data(using: .utf8) else {
            // Throw error
            return
        }
        let authBase64 = authBytes.base64EncodedString()
        let endpoint = LoadTokenEndpoint(headers: ["Authorization": authBase64])
        
        networkClient.makeRequest(endpoint) { result in
            switch result {
                case .success(let data):
                    do {
                        let token = try JSONDecoder().decode(AccessTokenResponse.self, from: data)
                        print(token.accessToken)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print("REQUEST FAIL: \(error.localizedDescription)")
            }
        }
    }
}
