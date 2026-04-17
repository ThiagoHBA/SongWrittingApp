import Foundation

struct AddNewRecordToSessionUseCaseInput: Equatable {
    let disco: DiscoSummary
    let section: Section
}

typealias AddNewRecordToSessionUseCaseOutput = DiscoProfile

protocol AddNewRecordToSessionUseCase {
    func addRecord(
        _ input: AddNewRecordToSessionUseCaseInput,
        completion: @escaping (Result<AddNewRecordToSessionUseCaseOutput, Error>) -> Void
    )
}
