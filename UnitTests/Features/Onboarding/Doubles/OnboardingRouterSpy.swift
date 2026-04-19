import Foundation
@testable import Main

final class OnboardingRouterSpy: OnboardingRouting {
    enum Message: Equatable {
        case showMainApp
    }

    private(set) var receivedMessages: [Message] = []

    func showMainApp() {
        receivedMessages.append(.showMainApp)
    }
}
