import Foundation

struct CreateNewDiscoUseCaseInput {
    let name: String
    let image: Data
}

protocol CreateNewDiscoUseCaseOutput: AnyObject {
    func successfullyCreateDisco(_ disco: DiscoSummary)
    func errorWhileCreatingDisco(_ error: Error)
}

final class CreateNewDiscoUseCase {
    private let repository: DiscoListRepository
    var output: [CreateNewDiscoUseCaseOutput] = []
    var input: CreateNewDiscoUseCaseInput?

    init(repository: DiscoListRepository) {
        self.repository = repository
    }

    func execute() {
        guard let input else { return }

        repository.createDisco(
            name: input.name,
            image: input.image
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let disco):
                output.forEach { $0.successfullyCreateDisco(disco) }
            case .failure(let error):
                output.forEach { $0.errorWhileCreatingDisco(error) }
            }
        }
    }
}
