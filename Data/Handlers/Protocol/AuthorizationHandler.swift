//
//  AuthorizationHandlerProtocol.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public protocol AuthorizationHandler {
    func loadToken (
        completion: @escaping (Result<AccessTokenResponse,TokenError>) -> Void
    )
}
