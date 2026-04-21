import Foundation

enum AppCrashReporterConfigurator {
    static func configure(
        crashReporter: CrashReporting,
        bundle: Bundle = .main
    ) {
        crashReporter.setValue(bundle.bundleIdentifier ?? "unknown", forKey: "bundle_id")
        crashReporter.setValue(infoValue("CFBundleShortVersionString", in: bundle), forKey: "app_version")
        crashReporter.setValue(infoValue("CFBundleVersion", in: bundle), forKey: "build_number")
        crashReporter.log("crash_reporting_configured")
        crashReporter.log("app_launch")
    }
}

private extension AppCrashReporterConfigurator {
    static func infoValue(_ key: String, in bundle: Bundle) -> String {
        bundle.object(forInfoDictionaryKey: key) as? String ?? "unknown"
    }
}
