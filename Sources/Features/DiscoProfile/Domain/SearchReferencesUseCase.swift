import Foundation

enum SearchReferencesUseCaseError: LocalizedError, Equatable {
    case noActiveSearchSession

    var errorDescription: String? {
        switch self {
        case .noActiveSearchSession:
            return "Nenhuma sessão ativa de busca por referências foi encontrada"
        }
    }
}

struct SearchReferencesUseCaseInput: Equatable {
    let keywords: String
    let provider: ReferenceProvider

    init(
        keywords: String,
        provider: ReferenceProvider = .spotify
    ) {
        self.keywords = keywords
        self.provider = provider
    }
}

typealias SearchReferencesUseCaseOutput = SearchReferencesPage

protocol SearchReferencesUseCase {
    func search(
        _ input: SearchReferencesUseCaseInput,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    )

    func loadMore(
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    )

    func reset()
}
