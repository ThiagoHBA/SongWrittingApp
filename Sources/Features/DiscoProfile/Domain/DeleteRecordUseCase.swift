import Foundation

struct DeleteRecordUseCaseInput: Equatable {
    let disco: DiscoSummary
    let sectionIdentifier: String
    let audioURL: URL
}

typealias DeleteRecordUseCaseOutput = DiscoProfile

protocol DeleteRecordUseCase {
    func deleteRecord(
        _ input: DeleteRecordUseCaseInput,
        completion: @escaping (Result<DeleteRecordUseCaseOutput, Error>) -> Void
    )
}
