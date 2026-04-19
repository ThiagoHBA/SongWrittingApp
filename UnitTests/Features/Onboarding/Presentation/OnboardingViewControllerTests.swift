import UIKit
import XCTest
@testable import Main

@MainActor
final class OnboardingViewControllerTests: XCTestCase {
    func test_viewDidLoad_requests_onboarding_pages() {
        let (sut, interactor, _, _) = makeSUT(loadView: false)

        sut.loadViewIfNeeded()

        XCTAssertEqual(interactor.receivedMessages, [.loadOnboarding])
    }

    func test_showPages_renders_first_page_content() throws {
        let (sut, _, _, _) = makeSUT()

        sut.showPages(makePages())

        XCTAssertEqual(try label(in: sut.view, identifier: "onboarding.page.title").text, "Bem vindo ao SongWrittingApp")
        XCTAssertEqual(
            try label(in: sut.view, identifier: "onboarding.page.message").text,
            "Agrupe suas músicas, organize elas em seções e busque por referências"
        )
    }

    func test_showPages_configures_page_control_and_primary_button() throws {
        let (sut, _, _, _) = makeSUT()

        sut.showPages(makePages())

        XCTAssertEqual(try pageControl(in: sut).numberOfPages, 3)
        XCTAssertEqual(try primaryButton(in: sut).title(for: .normal), "Próximo")
    }

    func test_primary_button_advances_to_next_page() throws {
        let (sut, interactor, _, _) = makeSUT()

        sut.showPages(makePages())
        interactor.reset()
        try tapPrimaryButton(on: sut)

        XCTAssertEqual(try pageControl(in: sut).currentPage, 1)
        XCTAssertEqual(interactor.receivedMessages, [])
    }

    func test_primary_button_on_last_page_requests_finish() throws {
        let (sut, interactor, _, _) = makeSUT()

        sut.showPages(makePages())
        interactor.reset()
        try tapPrimaryButton(on: sut)
        try tapPrimaryButton(on: sut)

        XCTAssertEqual(try primaryButton(in: sut).title(for: .normal), "Começar")

        try tapPrimaryButton(on: sut)

        XCTAssertEqual(interactor.receivedMessages, [.finish])
    }

    func test_skip_button_requests_skip() throws {
        let (sut, interactor, _, _) = makeSUT()

        sut.showPages(makePages())
        interactor.reset()

        try tapSkipButton(on: sut)

        XCTAssertEqual(interactor.receivedMessages, [.skip])
    }
}

private extension OnboardingViewControllerTests {
    func makeSUT(loadView: Bool = true) -> (
        sut: OnboardingViewController,
        interactor: OnboardingBusinessLogicSpy,
        navigationController: UINavigationController,
        window: UIWindow
    ) {
        let interactor = OnboardingBusinessLogicSpy()
        let sut = OnboardingViewController(interactor: interactor)
        let navigationController = UINavigationController(rootViewController: sut)
        let window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        if loadView {
            sut.loadViewIfNeeded()
        }

        return (sut, interactor, navigationController, window)
    }

    func makePages() -> [OnboardingPageViewEntity] {
        [
            OnboardingPageViewEntity(
                title: "Bem vindo ao SongWrittingApp",
                message: "Agrupe suas músicas, organize elas em seções e busque por referências",
                imageSource: .asset(name: "onboarding_app_icon")
            ),
            OnboardingPageViewEntity(
                title: "Em breve",
                message: "Conteúdo desta etapa será adicionado futuramente.",
                imageSource: .system(name: "music.note.list")
            ),
            OnboardingPageViewEntity(
                title: "Em breve",
                message: "Conteúdo desta etapa será adicionado futuramente.",
                imageSource: .system(name: "magnifyingglass")
            )
        ]
    }

    func pageControl(in sut: OnboardingViewController) throws -> UIPageControl {
        try XCTUnwrap(sut.view.findSubview(ofType: UIPageControl.self))
    }

    func primaryButton(in sut: OnboardingViewController) throws -> UIButton {
        try XCTUnwrap(sut.view.findButton(withAccessibilityLabel: "Ação principal onboarding"))
    }

    func label(in view: UIView, identifier: String) throws -> UILabel {
        try XCTUnwrap(view.findLabel(withIdentifier: identifier))
    }

    func tapPrimaryButton(on sut: OnboardingViewController) throws {
        try primaryButton(in: sut).sendActions(for: .touchUpInside)
    }

    func tapSkipButton(on sut: OnboardingViewController) throws {
        try XCTUnwrap(sut.view.findButton(withAccessibilityLabel: "Pular onboarding"))
            .sendActions(for: .touchUpInside)
    }
}

private extension UIView {
    func findSubview<T: UIView>(ofType type: T.Type) -> T? {
        if let typedView = self as? T {
            return typedView
        }

        for subview in subviews {
            if let typedView = subview.findSubview(ofType: type) {
                return typedView
            }
        }

        return nil
    }

    func findButton(withAccessibilityLabel accessibilityLabel: String) -> UIButton? {
        if let button = self as? UIButton, button.accessibilityLabel == accessibilityLabel {
            return button
        }

        for subview in subviews {
            if let button = subview.findButton(withAccessibilityLabel: accessibilityLabel) {
                return button
            }
        }

        return nil
    }

    func findLabel(withIdentifier identifier: String) -> UILabel? {
        if let label = self as? UILabel, label.accessibilityIdentifier == identifier {
            return label
        }

        for subview in subviews {
            if let label = subview.findLabel(withIdentifier: identifier) {
                return label
            }
        }

        return nil
    }
}
