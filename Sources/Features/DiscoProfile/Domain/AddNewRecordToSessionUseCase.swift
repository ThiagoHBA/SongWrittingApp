import Foundation

struct AddNewRecordToSessionUseCaseInput: Equatable {
    let disco: DiscoSummary
    let sectionIdentifier: String
    let audioFileURL: URL
}

typealias AddNewRecordToSessionUseCaseOutput = DiscoProfile

protocol AddNewRecordToSessionUseCase {
    func addRecord(
        _ input: AddNewRecordToSessionUseCaseInput,
        completion: @escaping (Result<AddNewRecordToSessionUseCaseOutput, Error>) -> Void
    )
}
