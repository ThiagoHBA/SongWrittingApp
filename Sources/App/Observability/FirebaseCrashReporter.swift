import FirebaseCrashlytics
import Foundation

final class FirebaseCrashReporter: CrashReporting {
    private enum Limits {
        static let maxValueLength = 100
    }

    func log(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }

    func setValue(_ value: String, forKey key: String) {
        Crashlytics.crashlytics().setCustomValue(sanitized(value), forKey: key)
    }
}

private extension FirebaseCrashReporter {
    func sanitized(_ value: String) -> String {
        String(value.prefix(Limits.maxValueLength))
    }
}
