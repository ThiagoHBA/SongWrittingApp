import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class OnboardingRouterSpy: OnboardingRouting {
    func showMainApp() {  }
}
