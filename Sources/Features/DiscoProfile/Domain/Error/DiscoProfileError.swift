import Foundation

enum DiscoProfileError: Error {
    enum CreateSectionError: LocalizedError {
        case emptyName

        var errorDescription: String? {
            switch self {
            case .emptyName:
                return "O nome da seção não pode ser vazio"
            }
        }

        static var errorTitle: String {
            "Campos Vazios"
        }
    }

    enum LoadReferencesError {
        static var errorTitle: String {
            "Erro ao encontrar referências"
        }
    }

    enum LoadingProfileError {
        static var errorTitle: String {
            "Erro ao carregar detalhes"
        }
    }

    enum AddingSectionsError {
        static var errorTitle: String {
            "Erro ao adicionar seção"
        }
    }

    enum AddingRecordsError {
        static var errorTitle: String {
            "Erro ao adicionar gravação"
        }
    }
}
