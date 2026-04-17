import Foundation

struct AddNewSectionToDiscoUseCaseInput {
    let disco: DiscoSummary
    let section: Section
}

protocol AddNewSectionToDiscoUseCaseOutput: AnyObject {
    func successfullyAddedSectionToDisco(_ disco: DiscoProfile)
    func errorWhileAddingSectionToDisco(_ error: Error)
}

final class AddNewSectionToDiscoUseCase {
    private let repository: DiscoProfileRepository
    var input: AddNewSectionToDiscoUseCaseInput?
    var output: [AddNewSectionToDiscoUseCaseOutput] = []

    init(repository: DiscoProfileRepository) {
        self.repository = repository
    }

    func execute() {
        guard let input else { return }

        repository.addSection(input.section, to: input.disco) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                output.forEach { $0.successfullyAddedSectionToDisco(profile) }
            case .failure(let error):
                output.forEach { $0.errorWhileAddingSectionToDisco(error) }
            }
        }
    }
}
