import Foundation

struct DeleteSectionUseCaseInput: Equatable {
    let disco: DiscoSummary
    let sectionIdentifier: String
}

typealias DeleteSectionUseCaseOutput = DiscoProfile

protocol DeleteSectionUseCase {
    func deleteSection(
        _ input: DeleteSectionUseCaseInput,
        completion: @escaping (Result<DeleteSectionUseCaseOutput, Error>) -> Void
    )
}
