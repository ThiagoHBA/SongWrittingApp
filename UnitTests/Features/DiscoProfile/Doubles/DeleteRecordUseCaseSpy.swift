import Foundation
@testable import Main

final class DeleteRecordUseCaseSpy: DeleteRecordUseCase {
    enum Message: Equatable {
        case deleteRecord(DeleteRecordUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completions: [(Result<DiscoProfile, Error>) -> Void] = []

    func deleteRecord(
        _ input: DeleteRecordUseCaseInput,
        completion: @escaping (Result<DeleteRecordUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.deleteRecord(input))
        completions.append(completion)
    }

    func completeDeleteRecord(with result: Result<DiscoProfile, Error>, at index: Int = 0) {
        completions[index](result)
    }
}
