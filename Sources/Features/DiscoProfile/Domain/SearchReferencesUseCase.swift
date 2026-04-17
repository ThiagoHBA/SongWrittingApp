import Foundation

struct SearchReferencesUseCaseInput {
    let keywords: String
}

protocol SearchReferencesUseCaseOutput: AnyObject {
    func didFindedReferences(_ data: [AlbumReference])
    func errorWhileFindingReferences(_ error: Error)
}

final class SearchReferencesUseCase {
    private let repository: ReferenceSearchRepository
    var input: SearchReferencesUseCaseInput?
    var output: [SearchReferencesUseCaseOutput] = []

    init(repository: ReferenceSearchRepository) {
        self.repository = repository
    }

    func execute() {
        guard let input else { return }

        repository.searchReferences(matching: input.keywords) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let references):
                output.forEach { $0.didFindedReferences(references) }
            case .failure(let error):
                output.forEach { $0.errorWhileFindingReferences(error) }
            }
        }
    }
}
