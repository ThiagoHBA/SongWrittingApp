import Foundation

protocol GetDiscosUseCaseOutput: AnyObject {
    func successfullyLoadDiscos(_ discos: [DiscoSummary])
    func errorWhileLoadingDiscos(_ error: Error)
}

final class GetDiscosUseCase {
    private let repository: DiscoListRepository
    var output: [GetDiscosUseCaseOutput] = []

    init(repository: DiscoListRepository) {
        self.repository = repository
    }

    func execute() {
        repository.getDiscos { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let discos):
                output.forEach { $0.successfullyLoadDiscos(discos) }
            case .failure(let error):
                output.forEach { $0.errorWhileLoadingDiscos(error) }
            }
        }
    }
}
