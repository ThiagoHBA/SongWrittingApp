import XCTest
@testable import Main

final class OnboardingInteractorTests: XCTestCase {
    func test_loadOnboarding_requests_presenter_to_present_pages() {
        let (sut, presenter, _, _) = makeSUT()

        sut.loadOnboarding()

        XCTAssertEqual(presenter.receivedMessages, [.presentPages])
    }

    func test_skip_marks_onboarding_as_completed_and_routes_to_main_app() {
        let (sut, _, completeOnboardingUseCase, router) = makeSUT()

        sut.skip()

        XCTAssertEqual(completeOnboardingUseCase.completeCallCount, 1)
        XCTAssertEqual(completeOnboardingUseCase.receivedCompleteInputs, [.init()])
        XCTAssertEqual(router.receivedMessages, [.showMainApp])
    }

    func test_finish_marks_onboarding_as_completed_and_routes_to_main_app() {
        let (sut, _, completeOnboardingUseCase, router) = makeSUT()

        sut.finish()

        XCTAssertEqual(completeOnboardingUseCase.completeCallCount, 1)
        XCTAssertEqual(completeOnboardingUseCase.receivedCompleteInputs, [.init()])
        XCTAssertEqual(router.receivedMessages, [.showMainApp])
    }
}

private extension OnboardingInteractorTests {
    func makeSUT() -> (
        sut: OnboardingInteractor,
        presenter: OnboardingPresenterSpy,
        completeOnboardingUseCase: OnboardingStatusUseCaseSpy,
        router: OnboardingRouterSpy
    ) {
        let completeOnboardingUseCase = OnboardingStatusUseCaseSpy()
        let presenter = OnboardingPresenterSpy()
        let router = OnboardingRouterSpy()
        let sut = OnboardingInteractor(completeOnboardingUseCase: completeOnboardingUseCase)

        sut.presenter = presenter
        sut.router = router

        return (sut, presenter, completeOnboardingUseCase, router)
    }
}
