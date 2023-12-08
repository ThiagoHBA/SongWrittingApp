//
//  DataError.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

internal enum DataError: LocalizedError {
    case unableToCreateToken
    case decodingError
}

extension DataError {
    var errorDescription: String? {
        switch self {
            case .decodingError:
                return "Não foi possível mapear as informações do servidor"
            case .unableToCreateToken:
                return "Ocorreu um problema ao realizar autenticação com o servidor"
        }
    }
}
