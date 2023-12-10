//
//  DiscoListError.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public enum DiscoListError: Error {
    public enum CreateDiscoError: LocalizedError {
        case emptyName
        case emptyImage
        
        public var errorDescription: String? {
            switch self {
                case .emptyName:
                    return "O campo nome não pode ser vazio"
                case .emptyImage:
                    return "O Disco precisa de uma imagem"
            }
        }
        
        static var errorTitle: String {
            return "Campos Vazios"
        }
    }
    
    public enum LoadDiscoError {
        static var errorTitle: String {
            return "Erro ao carregar discos"
        }
    }
}
