//
//  DiscoListError.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public enum DiscoListError: LocalizedError {
    case emptyFields(CreateDiscoError)
    
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
    }
}

extension DiscoListError {
    public var errorDescription: String? {
        switch self {
            
        case .emptyFields(let discoError):
            return "Campos Vazios: \(discoError.localizedDescription)"
        }
    }
}
