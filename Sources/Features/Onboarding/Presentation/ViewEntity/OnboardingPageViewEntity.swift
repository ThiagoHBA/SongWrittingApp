import Foundation

enum OnboardingPageImageSource: Equatable {
    case asset(name: String)
    case system(name: String)
    case gif(name: String)
}

struct OnboardingPageViewEntity: Equatable {
    let title: String
    let message: String
    let imageSource: OnboardingPageImageSource
    let imageScale: CGFloat?

    init(
        title: String,
        message: String,
        imageSource: OnboardingPageImageSource,
        imageScale: CGFloat? = nil
    ) {
        self.title = title
        self.message = message
        self.imageSource = imageSource
        self.imageScale = imageScale
    }
}
