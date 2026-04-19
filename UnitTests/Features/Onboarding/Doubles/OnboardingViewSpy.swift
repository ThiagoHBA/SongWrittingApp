import Foundation
@testable import Main

final class OnboardingViewSpy: OnboardingDisplayLogic {
    private(set) var receivedPages: [[OnboardingPageViewEntity]] = []

    func showPages(_ pages: [OnboardingPageViewEntity]) {
        receivedPages.append(pages)
    }
}
