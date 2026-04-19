import Foundation
import XCTest
@testable import Main

final class UserDefaultsClientImplTests: XCTestCase {
    func test_bool_returns_false_when_key_is_missing() {
        let (sut, _, key) = makeSUT()

        XCTAssertFalse(sut.bool(forKey: key))
    }

    func test_set_persists_boolean_for_key() {
        let (sut, userDefaults, key) = makeSUT()

        sut.set(true, forKey: key)

        XCTAssertEqual(userDefaults.object(forKey: key) as? Bool, true)
    }

    func test_bool_returns_stored_boolean() {
        let (sut, _, key) = makeSUT()

        sut.set(true, forKey: key)

        XCTAssertTrue(sut.bool(forKey: key))
    }
}

private extension UserDefaultsClientImplTests {
    func makeSUT() -> (sut: UserDefaultsClientImpl, userDefaults: UserDefaults, key: String) {
        let suiteName = "UserDefaultsClientImplTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        let sut = UserDefaultsClientImpl(userDefaults: userDefaults)
        let key = "test.key"

        addTeardownBlock {
            userDefaults.removePersistentDomain(forName: suiteName)
        }

        return (sut, userDefaults, key)
    }
}
