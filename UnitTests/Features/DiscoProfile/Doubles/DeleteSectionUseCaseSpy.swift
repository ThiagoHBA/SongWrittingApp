import Foundation
import SongWrittingMacros
@testable import Main


@SWSpy
final class DeleteSectionUseCaseSpy: DeleteSectionUseCase {
    private var completions: [(Result<DiscoProfile, Error>) -> Void] = []

    @SWSpyMethodTracker
    func deleteSection(
        _ input: DeleteSectionUseCaseInput,
        completion: @escaping (Result<DeleteSectionUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.deleteSection(input))
        completions.append(completion)
    }

    func completeDeleteSection(with result: Result<DiscoProfile, Error>, at index: Int = 0) {
        completions[index](result)
    }
}
