import Foundation

protocol CrashReporting {
    func log(_ message: String)
    func setValue(_ value: String, forKey key: String)
}

final class NoOpCrashReporter: CrashReporting {
    func log(_ message: String) {}

    func setValue(_ value: String, forKey key: String) {}
}
