import UIKit

protocol DiscoListRouting: AnyObject {
    func showProfile(of disco: DiscoSummary)
}

final class DiscoListRouter: DiscoListRouting {
    private let navigationController: UINavigationController
    private let discoProfileViewController: (DiscoSummary) -> UIViewController

    init(
        navigationController: UINavigationController,
        discoProfileViewController: @escaping (DiscoSummary) -> UIViewController
    ) {
        self.navigationController = navigationController
        self.discoProfileViewController = discoProfileViewController
    }

    func showProfile(of disco: DiscoSummary) {
        navigationController.pushViewController(
            discoProfileViewController(disco),
            animated: true
        )
    }
}
