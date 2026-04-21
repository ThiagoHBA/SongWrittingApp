import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class DeleteRecordUseCaseSpy: DeleteRecordUseCase {
    private var completions: [(Result<DiscoProfile, Error>) -> Void] = []

    @SWSpyMethodTracker
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
