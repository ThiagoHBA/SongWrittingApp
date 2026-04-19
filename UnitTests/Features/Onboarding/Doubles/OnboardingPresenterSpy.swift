import Foundation
@testable import Main

final class OnboardingPresenterSpy: OnboardingPresentationLogic {
    enum Message: Equatable {
        case presentPages
    }

    private(set) var receivedMessages: [Message] = []

    func presentPages() {
        receivedMessages.append(.presentPages)
    }
}
