import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class OnboardingViewSpy: OnboardingDisplayLogic {
    func showPages(_ pages: [OnboardingPageViewEntity]) { }
}
