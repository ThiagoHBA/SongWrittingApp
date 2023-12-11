//
//  DataError.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

internal enum DataError: LocalizedError {
    case decodingError
    case cantFindDisco
}

extension DataError {
    var errorDescription: String? {
        switch self {
            case .decodingError:
                return "Não foi possível mapear as informações do servidor"
            case .cantFindDisco:
                return "Não foi possível encontrar o disco desejado para completar as operações"
        }
    }
}
