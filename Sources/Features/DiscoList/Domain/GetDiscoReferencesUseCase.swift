import Foundation

typealias GetDiscoReferencesUseCaseInput = DiscoSummary
typealias GetDiscoReferencesUseCaseOutput = [AlbumReference]

protocol GetDiscoReferencesUseCase {
    func loadReferences(
        _ input: GetDiscoReferencesUseCaseInput,
        completion: @escaping (Result<GetDiscoReferencesUseCaseOutput, Error>) -> Void
    )
}
