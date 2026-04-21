import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class OnboardingBusinessLogicSpy: OnboardingBusinessLogic {
    func loadOnboarding() { }

    func skip() { }

    func finish() {  }

    func reset() { }
}
