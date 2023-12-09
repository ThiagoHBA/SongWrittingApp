//
//  TokenError.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public enum TokenError: LocalizedError {
    case unableToCreateToken
    case needToRefresh
    case requestError(Error)
}

extension TokenError {
    public var errorDescription: String? {
        return "Não foi possível realizar a autenticação com o servidor, reinicie o aplicativo e tente novamente!"
    }
}
