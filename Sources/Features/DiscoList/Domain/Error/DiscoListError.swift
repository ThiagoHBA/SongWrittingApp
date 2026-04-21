import Foundation

enum DiscoListError: Error {
    enum CreateDiscoError: LocalizedError {
        case emptyName
        case emptyImage

        var errorDescription: String? {
            switch self {
            case .emptyName:
                return "O campo nome não pode ser vazio"
            case .emptyImage:
                return "O Disco precisa de uma imagem"
            }
        }

        static var errorTitle: String {
            "Erro ao criar disco"
        }
    }

    enum LoadDiscoError {
        static var errorTitle: String {
            "Erro ao carregar discos"
        }
    }

    enum DeleteDiscoError {
        static var errorTitle: String {
            "Erro ao deletar disco"
        }
    }
}
