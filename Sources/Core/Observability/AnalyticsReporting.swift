import Foundation

protocol AnalyticsReporting {
    func logEvent(_ name: String, parameters: [String: Any]?)
}

final class NoOpAnalyticsReporter: AnalyticsReporting {
    func logEvent(_ name: String, parameters: [String: Any]?) {}
}
