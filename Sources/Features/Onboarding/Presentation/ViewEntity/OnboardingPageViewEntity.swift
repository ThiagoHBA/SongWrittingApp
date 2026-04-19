import Foundation

enum OnboardingPageImageSource: Equatable {
    case asset(name: String)
    case system(name: String)
}

struct OnboardingPageViewEntity: Equatable {
    let title: String
    let message: String
    let imageSource: OnboardingPageImageSource
}
