import Foundation

typealias SearchReferencesUseCaseInput = String
typealias SearchReferencesUseCaseOutput = [AlbumReference]

protocol SearchReferencesUseCase {
    func search(
        _ input: SearchReferencesUseCaseInput,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    )
}
