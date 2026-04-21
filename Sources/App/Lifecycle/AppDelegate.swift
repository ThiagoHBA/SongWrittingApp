import UIKit
import FirebaseCore

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        let crashReporter = FirebaseCrashReporter()
        let analyticsReporter = FirebaseAnalyticsReporter()
        AppContainer.configureCrashReporterFactory { crashReporter }
        AppContainer.configureAnalyticsReporterFactory { analyticsReporter }
        AppCrashReporterConfigurator.configure(crashReporter: crashReporter)
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}
