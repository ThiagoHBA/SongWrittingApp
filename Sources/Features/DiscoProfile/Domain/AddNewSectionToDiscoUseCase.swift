import Foundation

struct AddNewSectionToDiscoUseCaseInput: Equatable {
    let disco: DiscoSummary
    let section: Section
}

typealias AddNewSectionToDiscoUseCaseOutput = DiscoProfile

protocol AddNewSectionToDiscoUseCase {
    func addSection(
        _ input: AddNewSectionToDiscoUseCaseInput,
        completion: @escaping (Result<AddNewSectionToDiscoUseCaseOutput, Error>) -> Void
    )
}
