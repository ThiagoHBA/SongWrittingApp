import UIKit
import XCTest
@testable import Main

final class ComposerMemoryLeakTests: XCTestCase {
    override func setUp() {
        super.setUp()
        AppContainer.setShared(makeInMemoryContainer())
    }

    func test_discoProfileComposer_make_doesNotLeak() {
        weak var weakSUT: UIViewController?

        autoreleasepool {
            var sut: UIViewController? = DiscoProfileComposer.make(with: makeDisco())

            sut?.loadViewIfNeeded()
            weakSUT = sut
            sut = nil
        }

        XCTAssertNil(weakSUT)
    }

    func test_discoListComposer_make_doesNotLeak() {
        weak var weakSUT: UIViewController?
        weak var weakNavigationController: UINavigationController?

        autoreleasepool {
            let createdNavigationController = UINavigationController()
            var navigationController: UINavigationController? = createdNavigationController
            var sut: UIViewController? = DiscoListComposer.make(
                navigationController: createdNavigationController
            )

            sut?.loadViewIfNeeded()
            weakSUT = sut
            weakNavigationController = navigationController
            sut = nil
            navigationController = nil
        }

        XCTAssertNil(weakSUT)
        XCTAssertNil(weakNavigationController)
    }

    func test_onboardingComposer_make_doesNotLeak() {
        weak var weakSUT: UIViewController?
        weak var weakNavigationController: UINavigationController?

        autoreleasepool {
            let completeOnboardingUseCase = OnboardingStatusUseCaseSpy()
            let createdNavigationController = UINavigationController()
            var navigationController: UINavigationController? = createdNavigationController
            var sut: UIViewController? = OnboardingComposer.make(
                navigationController: createdNavigationController,
                completeOnboardingUseCase: completeOnboardingUseCase
            )

            sut?.loadViewIfNeeded()
            weakSUT = sut
            weakNavigationController = navigationController
            sut = nil
            navigationController = nil
        }

        XCTAssertNil(weakSUT)
        XCTAssertNil(weakNavigationController)
    }
}

private extension ComposerMemoryLeakTests {
    func makeDisco() -> DiscoSummary {
        DiscoSummary(
            id: UUID(),
            name: "Any Disco",
            coverImage: Data("cover".utf8)
        )
    }

    func makeInMemoryContainer() -> AppContainer {
        try! AppContainer(storage: .inMemory())
    }
}
