//
//  DiscoProfileError.swift
//  Presentation
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation

public enum DiscoProfileError: Error {
    public enum CreateSectionError: LocalizedError {
        case emptyName
        
        public var errorDescription: String? {
            switch self {
                case .emptyName:
                    return "O nome da seção não pode ser vazio"
            }
        }
    }
}
