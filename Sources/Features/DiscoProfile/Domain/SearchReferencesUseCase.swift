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
    let pageSize: Int
    let provider: ReferenceProvider

    init(
        keywords: String,
        pageSize: Int,
        provider: ReferenceProvider = .spotify
    ) {
        self.keywords = keywords
        self.pageSize = pageSize
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
