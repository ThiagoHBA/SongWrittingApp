import Foundation

struct AddNewRecordToSessionUseCaseInput {
    let disco: DiscoSummary
    let section: Section
}

protocol AddNewRecordToSessionUseCaseOutput: AnyObject {
    func successfullyAddedNewRecordToSection(_ profile: DiscoProfile)
    func errorWhileAddingNewRecordToSection(_ error: Error)
}

final class AddNewRecordToSessionUseCase {
    private let repository: DiscoProfileRepository
    var input: AddNewRecordToSessionUseCaseInput?
    var output: [AddNewRecordToSessionUseCaseOutput] = []

    init(repository: DiscoProfileRepository) {
        self.repository = repository
    }

    func execute() {
        guard let input else { return }

        repository.addRecord(in: input.disco, to: input.section) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                output.forEach { $0.successfullyAddedNewRecordToSection(profile) }
            case .failure(let error):
                output.forEach { $0.errorWhileAddingNewRecordToSection(error) }
            }
        }
    }
}
