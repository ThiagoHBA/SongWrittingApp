import Foundation

struct GetDiscoProfileUseCaseInput {
    let disco: DiscoSummary
}

protocol GetDiscoProfileUseCaseOutput: AnyObject {
    func succesfullyLoadProfile(_ profile: DiscoProfile)
    func errorWhileLoadingProfile(_ error: Error)
}

final class GetDiscoProfileUseCase {
    private let repository: DiscoProfileRepository
    var input: GetDiscoProfileUseCaseInput?
    var output: [GetDiscoProfileUseCaseOutput] = []

    init(repository: DiscoProfileRepository) {
        self.repository = repository
    }

    func execute() {
        guard let input else { return }

        repository.loadProfile(for: input.disco) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                output.forEach { $0.succesfullyLoadProfile(profile) }
            case .failure(let error):
                output.forEach { $0.errorWhileLoadingProfile(error) }
            }
        }
    }
}
