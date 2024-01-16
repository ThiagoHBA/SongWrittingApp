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
    case nameAlreadyExist
    case cantFindSection
    case loadModelError
}

extension DataError {
    var errorDescription: String? {
        switch self {
        case.decodingError:
            return "Não foi possível mapear as informações do servidor"
        case.cantFindDisco:
            return "Não foi possível encontrar o disco desejado para completar as operações"
        case.loadModelError:
            return "Erro ao carregar dados"
        case .nameAlreadyExist:
            return "Um disco com o mesmo nome já foi criado"
        case .cantFindSection:
            return "Não foi possível encontrar a sessão para adição da gravação"
        }
    }
}
