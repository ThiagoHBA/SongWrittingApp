//
//  FallbackError.swift
//  Main
//
//  Created by Thiago Henrique on 12/12/23.
//

import Foundation

enum FallbackError {
    case primaryFailed
}

extension FallbackError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .primaryFailed:
                return "Ocorreu um problema ao consultar o serviço principal, É possível que aconteça algumas instabilidades na utilização do aplicativo"
        }
    }
}
