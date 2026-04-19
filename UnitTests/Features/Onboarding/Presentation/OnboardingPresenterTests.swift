import XCTest
@testable import Main

final class OnboardingPresenterTests: XCTestCase {
    func test_presentPages_displays_three_pages() {
        let (sut, view) = makeSUT()

        sut.presentPages()

        XCTAssertEqual(view.receivedPages.first?.count, 3)
    }

    func test_presentPages_displays_expected_first_page_content() {
        let (sut, view) = makeSUT()

        sut.presentPages()

        XCTAssertEqual(
            view.receivedPages.first?.first,
            OnboardingPageViewEntity(
                title: "Bem vindo ao SongWrittingApp",
                message: "Agrupe suas músicas, organize elas em seções e busque por referências",
                imageSource: .asset(name: "onboarding_app_icon")
            )
        )
    }
}

private extension OnboardingPresenterTests {
    func makeSUT() -> (sut: OnboardingPresenter, view: OnboardingViewSpy) {
        let view = OnboardingViewSpy()
        let sut = OnboardingPresenter()
        sut.view = view
        return (sut, view)
    }
}
