import Foundation

enum UserDefaultsOnboardingStatusRepositoryKeys {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
}

final class UserDefaultsOnboardingStatusRepository: OnboardingStatusRepository {
    private let client: UserDefaultsClient
    private let completedOnboardingKey: String

    init(
        client: UserDefaultsClient,
        completedOnboardingKey: String = UserDefaultsOnboardingStatusRepositoryKeys.hasCompletedOnboarding
    ) {
        self.client = client
        self.completedOnboardingKey = completedOnboardingKey
    }

    func load(_ input: GetOnboardingStatusUseCaseInput) -> GetOnboardingStatusUseCaseOutput {
        guard client.object(forKey: completedOnboardingKey) != nil else {
            return false
        }

        return client.bool(forKey: completedOnboardingKey)
    }

    func complete(_ input: CompleteOnboardingUseCaseInput) {
        client.set(true, forKey: completedOnboardingKey)
    }
}
