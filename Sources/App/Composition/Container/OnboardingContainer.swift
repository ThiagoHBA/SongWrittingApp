import Foundation

final class OnboardingContainer {
    let app: AppContainer

    init(app: AppContainer) {
        self.app = app
    }

    lazy var onboardingStatusRepository: OnboardingStatusRepository = {
        UserDefaultsOnboardingStatusRepository(client: app.userDefaultsClient)
    }()
}
