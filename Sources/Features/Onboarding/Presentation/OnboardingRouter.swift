import UIKit

protocol OnboardingRouting: AnyObject {
    func showMainApp()
}

final class OnboardingRouter: OnboardingRouting {
    private let navigationController: UINavigationController
    private let mainAppViewController: () -> UIViewController

    init(
        navigationController: UINavigationController,
        mainAppViewController: @escaping () -> UIViewController
    ) {
        self.navigationController = navigationController
        self.mainAppViewController = mainAppViewController
    }

    func showMainApp() {
        navigationController.setViewControllers(
            [mainAppViewController()],
            animated: true
        )
    }
}
