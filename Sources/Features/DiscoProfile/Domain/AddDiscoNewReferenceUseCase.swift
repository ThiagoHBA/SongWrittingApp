import Foundation

struct AddDiscoNewReferenceUseCaseInput: Equatable {
    let disco: DiscoSummary
    let newReferences: [AlbumReference]
}

typealias AddDiscoNewReferenceUseCaseOutput = DiscoProfile

protocol AddDiscoNewReferenceUseCase {
    func addReferences(
        _ input: AddDiscoNewReferenceUseCaseInput,
        completion: @escaping (Result<AddDiscoNewReferenceUseCaseOutput, Error>) -> Void
    )
}
