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

        static var errorTitle: String {
            return "Campos Vazios"
        }
    }

    public enum LoadReferencesError {
        static var errorTitle: String {
            return "Erro ao encontrar referências"
        }
    }

    public enum LoadingProfileError {
        static var errorTitle: String {
            return "Erro ao carregar detalhes"
        }
    }

    public enum AddingSectionsError {
        static var errorTitle: String {
            return "Erro ao adicionar seção"
        }
    }

    public enum AddingRecordsError {
        static var errorTitle: String {
            return "Erro ao adicionar gravação"
        }
    }
}
