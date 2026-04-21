import Foundation
import XCTest
@testable import Main

final class UserDefaultsOnboardingStatusRepositoryTests: XCTestCase {
    func test_hasCompletedOnboarding_returns_false_when_value_is_missing() {
        let (sut, _) = makeSUT()

        XCTAssertFalse(sut.load(.init()))
    }

    func test_completeOnboarding_persists_true_value() {
        let (sut, userDefaults) = makeSUT()

        sut.complete(.init())

        XCTAssertEqual(
            userDefaults.object(forKey: UserDefaultsOnboardingStatusRepositoryKeys.hasCompletedOnboarding) as? Bool,
            true
        )
    }

    func test_hasCompletedOnboarding_returns_true_after_completion() {
        let (sut, _) = makeSUT()

        sut.complete(.init())

        XCTAssertTrue(sut.load(.init()))
    }
}

private extension UserDefaultsOnboardingStatusRepositoryTests {
    func makeSUT() -> (sut: UserDefaultsOnboardingStatusRepository, userDefaults: UserDefaults) {
        let suiteName = "UserDefaultsOnboardingStatusRepositoryTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        let client = UserDefaultsClientImpl(userDefaults: userDefaults)
        let sut = UserDefaultsOnboardingStatusRepository(client: client)

        addTeardownBlock {
            userDefaults.removePersistentDomain(forName: suiteName)
        }

        return (sut, userDefaults)
    }
}
