import UIKit
import XCTest
@testable import Main

@MainActor
final class AppRootComposerTests: XCTestCase {
    func test_make_returns_onboarding_when_user_has_not_completed_it() {
        let navigationController = UINavigationController()
        let useCase = OnboardingStatusUseCaseSpy()
        useCase.loadResult = false

        let sut = AppRootComposer.make(
            navigationController: navigationController,
            getOnboardingStatusUseCase: useCase,
            completeOnboardingUseCase: useCase
        )

        XCTAssertTrue(sut is OnboardingViewController)
        XCTAssertEqual(useCase.loadCallCount, 1)
        XCTAssertEqual(useCase.receivedLoadInputs, [.init()])
    }

    func test_make_returns_disco_list_when_user_has_completed_onboarding() {
        let navigationController = UINavigationController()
        let useCase = OnboardingStatusUseCaseSpy()
        useCase.loadResult = true

        let sut = AppRootComposer.make(
            navigationController: navigationController,
            getOnboardingStatusUseCase: useCase,
            completeOnboardingUseCase: useCase
        )

        XCTAssertTrue(sut is DiscoListViewController)
        XCTAssertEqual(useCase.loadCallCount, 1)
        XCTAssertEqual(useCase.receivedLoadInputs, [.init()])
    }
}
