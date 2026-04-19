import UIKit

enum OnboardingComposer {
    static func make(
        navigationController: UINavigationController,
        completeOnboardingUseCase: CompleteOnboardingUseCase
    ) -> UIViewController {
        let presenter = OnboardingPresenter()
        let interactor = OnboardingInteractor(completeOnboardingUseCase: completeOnboardingUseCase)
        let viewController = OnboardingViewController(interactor: interactor)
        let router = OnboardingRouter(
            navigationController: navigationController,
            mainAppViewController: {
                DiscoListComposer.make(navigationController: navigationController)
            }
        )

        interactor.presenter = presenter
        interactor.router = router
        presenter.view = MainQueueProxy(WeakReferenceProxy(viewController))

        return viewController
    }
}

extension WeakReferenceProxy: OnboardingDisplayLogic where T: OnboardingDisplayLogic {
    func showPages(_ pages: [OnboardingPageViewEntity]) {
        instance?.showPages(pages)
    }
}

extension MainQueueProxy: OnboardingDisplayLogic where T: OnboardingDisplayLogic {
    func showPages(_ pages: [OnboardingPageViewEntity]) {
        DispatchQueue.main.async {
            self.instance.showPages(pages)
        }
    }
}
