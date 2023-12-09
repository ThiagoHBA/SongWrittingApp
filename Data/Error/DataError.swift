//
//  DataError.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

internal enum DataError: LocalizedError {
    case decodingError
}

extension DataError {
    var errorDescription: String? {
        switch self {
            case .decodingError:
                return "Não foi possível mapear as informações do servidor"
        }
    }
}
