import UIKit

enum AppRootComposer {
    static func make(navigationController: UINavigationController) -> UIViewController {
        let appContainer = AppContainer.shared
        let onboardingContainer = OnboardingContainer(app: appContainer)
        let onboardingStatusRepository = onboardingContainer.onboardingStatusRepository

        return make(
            navigationController: navigationController,
            getOnboardingStatusUseCase: onboardingStatusRepository,
            completeOnboardingUseCase: onboardingStatusRepository,
            appContainer: appContainer
        )
    }

    static func make(
        navigationController: UINavigationController,
        getOnboardingStatusUseCase: GetOnboardingStatusUseCase,
        completeOnboardingUseCase: CompleteOnboardingUseCase,
        appContainer: AppContainer = .shared
    ) -> UIViewController {
        guard getOnboardingStatusUseCase.load(.init()) else {
            return OnboardingComposer.make(
                navigationController: navigationController,
                completeOnboardingUseCase: completeOnboardingUseCase,
                container: OnboardingContainer(app: appContainer)
            )
        }

        return DiscoListComposer.make(
            navigationController: navigationController,
            container: DiscoListContainer(app: appContainer)
        )
    }
}
