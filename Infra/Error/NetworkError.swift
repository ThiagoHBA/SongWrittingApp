//
//  InfraError.swift
//  Infra
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation

public enum NetworkError: LocalizedError, Equatable {
    case unableToCreateURL
    case transportError
    case httpError(Int)
    case decodingError
}

extension NetworkError {
    public var errorDescription: String? {
        switch self {
        case .unableToCreateURL:
            return "Não foi possível estabeler conexão com o servidor"
        case .transportError:
            return "Ocorreu um erro ao requisitar dados do servidor"
        case .httpError(let statusCode):
            return retrieveResponseForHttp(statusCode)
        case .decodingError:
            return "Não foi possível mapear as informações do servidor"
        }
    }

    func retrieveResponseForHttp(_ code: Int) -> String {
        if (400...499).contains(code) {
             return "Por favor, certifique-se de preencher todos os campos obrigatórios corretamente. \(code)"
         } else if (500...599).contains(code) {
             return "Desculpe, não foi possível acessar nosso servidor. \(code)"
         } else if (700...).contains(code) {
             return "Desculpe, algo deu errado. Tente mais tarde. \(code)"
         }

         return "Erro desconhecido"
    }
}
