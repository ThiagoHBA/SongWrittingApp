import Foundation

protocol UserDefaultsClient {
    func bool(forKey defaultName: String) -> Bool
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Bool, forKey defaultName: String)
    func removeObject(forKey defaultName: String)
}

final class UserDefaultsClientImpl: UserDefaultsClient {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func bool(forKey defaultName: String) -> Bool {
        userDefaults.bool(forKey: defaultName)
    }

    func object(forKey defaultName: String) -> Any? {
        userDefaults.object(forKey: defaultName)
    }

    func set(_ value: Bool, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
    }

    func removeObject(forKey defaultName: String) {
        userDefaults.removeObject(forKey: defaultName)
    }
}
