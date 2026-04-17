import Foundation

struct AddDiscoNewReferenceInput {
    let disco: DiscoSummary
    let newReferences: [AlbumReference]
}

protocol AddDiscoNewReferenceUseCaseOutput: AnyObject {
    func successfullyAddNewReferences(to disco: DiscoSummary, references: [AlbumReference])
    func errorWhileAddingNewReferences(_ error: Error)
}

final class AddDiscoNewReferenceUseCase {
    private let repository: DiscoProfileRepository
    var output: [AddDiscoNewReferenceUseCaseOutput] = []
    var input: AddDiscoNewReferenceInput?

    init(repository: DiscoProfileRepository) {
        self.repository = repository
    }

    func execute() {
        guard let input else { return }

        repository.addReferences(
            input.newReferences,
            to: input.disco
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                output.forEach {
                    $0.successfullyAddNewReferences(
                        to: profile.disco,
                        references: profile.references
                    )
                }
            case .failure(let error):
                output.forEach { $0.errorWhileAddingNewReferences(error) }
            }
        }
    }
}
