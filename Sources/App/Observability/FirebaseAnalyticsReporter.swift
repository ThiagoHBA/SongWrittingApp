import FirebaseAnalytics
import Foundation

final class FirebaseAnalyticsReporter: AnalyticsReporting {
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
