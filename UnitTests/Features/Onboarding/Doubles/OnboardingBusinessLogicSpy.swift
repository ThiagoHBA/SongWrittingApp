import Foundation
@testable import Main

final class OnboardingBusinessLogicSpy: OnboardingBusinessLogic {
    enum Message: Equatable {
        case loadOnboarding
        case skip
        case finish
    }

    private(set) var receivedMessages: [Message] = []

    func loadOnboarding() {
        receivedMessages.append(.loadOnboarding)
    }

    func skip() {
        receivedMessages.append(.skip)
    }

    func finish() {
        receivedMessages.append(.finish)
    }

    func reset() {
        receivedMessages.removeAll()
    }
}
