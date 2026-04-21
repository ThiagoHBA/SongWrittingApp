import UIKit
import XCTest
@testable import Main

@MainActor
final class DiscoListRouterTests: XCTestCase {
    func test_showProfile_pushes_viewController_onto_navigationStack() {
        let (sut, navigationController, _) = makeSUT()
        let disco = makeDiscoSummary()

        sut.showProfile(of: disco)

        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }

    func test_showProfile_calls_factory_with_correct_disco() {
        let (sut, _, capturedDiscos) = makeSUT()
        let disco = makeDiscoSummary(name: "Dark Side of the Moon")

        sut.showProfile(of: disco)

        XCTAssertEqual(capturedDiscos(), [disco])
    }

    func test_showProfile_pushes_viewController_returned_by_factory() {
        let expectedViewController = UIViewController()
        let (sut, navigationController, _) = makeSUT(makeViewController: { expectedViewController })
        let disco = makeDiscoSummary()

        sut.showProfile(of: disco)

        XCTAssertTrue(navigationController.topViewController === expectedViewController)
    }

    func test_showProfile_called_twice_pushes_two_viewControllers() {
        let (sut, navigationController, capturedDiscos) = makeSUT()
        let first = makeDiscoSummary(name: "Abbey Road")
        let second = makeDiscoSummary(name: "Rumours")

        sut.showProfile(of: first)
        sut.showProfile(of: second)

        XCTAssertEqual(navigationController.viewControllers.count, 3)
        XCTAssertEqual(capturedDiscos(), [first, second])
    }
}

extension DiscoListRouterTests {
    typealias SutAndDoubles = (
        sut: DiscoListRouter,
        navigationController: UINavigationController,
        capturedDiscos: () -> [DiscoSummary]
    )

    @MainActor private func makeSUT(
        makeViewController: @MainActor @escaping () -> UIViewController = { @MainActor in UIViewController() }
    ) -> SutAndDoubles {
        var receivedDiscos: [DiscoSummary] = []
        let navigationController = UINavigationController(rootViewController: UIViewController())

        let sut = DiscoListRouter(
            navigationController: navigationController,
            discoProfileViewController: { disco in
                receivedDiscos.append(disco)
                return makeViewController()
            }
        )

        return (sut, navigationController, { receivedDiscos })
    }
}

private extension DiscoListRouterTests {
    func makeDiscoSummary(
        id: UUID = UUID(),
        name: String = "Any Disco",
        coverImage: Data = Data("cover".utf8)
    ) -> DiscoSummary {
        DiscoSummary(id: id, name: name, coverImage: coverImage)
    }
}
