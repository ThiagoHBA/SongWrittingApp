import Foundation
@testable import Main

final class DeleteSectionUseCaseSpy: DeleteSectionUseCase {
    enum Message: Equatable {
        case deleteSection(DeleteSectionUseCaseInput)
    }

    private(set) var receivedMessages: [Message] = []
    private var completions: [(Result<DiscoProfile, Error>) -> Void] = []

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
