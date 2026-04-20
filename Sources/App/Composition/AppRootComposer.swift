import UIKit

enum AppRootComposer {
    static func make(navigationController: UINavigationController) -> UIViewController {
        let onboardingStatusRepository = makeOnboardingStatusRepository()

        return make(
            navigationController: navigationController,
            getOnboardingStatusUseCase: onboardingStatusRepository,
            completeOnboardingUseCase: onboardingStatusRepository
        )
    }

    static func make(
        navigationController: UINavigationController,
        getOnboardingStatusUseCase: GetOnboardingStatusUseCase,
        completeOnboardingUseCase: CompleteOnboardingUseCase
    ) -> UIViewController {
//        guard getOnboardingStatusUseCase.load(.init()) else {
            return OnboardingComposer.make(
                navigationController: navigationController,
                completeOnboardingUseCase: completeOnboardingUseCase
            )
//        }

        return DiscoListComposer.make(navigationController: navigationController)
    }
}

private extension AppRootComposer {
    static func makeOnboardingStatusRepository() -> OnboardingStatusRepository {
        UserDefaultsOnboardingStatusRepository(client: UserDefaultsClientImpl())
    }
}
