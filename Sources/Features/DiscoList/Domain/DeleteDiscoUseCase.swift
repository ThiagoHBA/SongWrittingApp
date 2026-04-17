import Foundation

struct DeleteDiscoUseCaseInput {
    let disco: DiscoSummary
}

protocol DeleteDiscoUseCaseOutput: AnyObject {
    func successfullyDeleteDisco(_ disco: DiscoSummary)
    func errorWhileDeletingDisco(_ error: Error)
}

final class DeleteDiscoUseCase {
    private let repository: DiscoListRepository
    var output: [DeleteDiscoUseCaseOutput] = []
    var input: DeleteDiscoUseCaseInput?

    init(repository: DiscoListRepository) {
        self.repository = repository
    }

    func execute() {
        guard let input else { return }

        repository.deleteDisco(input.disco) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                output.forEach { $0.successfullyDeleteDisco(input.disco) }
            case .failure(let error):
                output.forEach { $0.errorWhileDeletingDisco(error) }
            }
        }
    }
}
