import Foundation

protocol OnboardingBusinessLogic: AnyObject {
    func loadOnboarding()
    func skip()
    func finish()
}

final class OnboardingInteractor: OnboardingBusinessLogic {
    var presenter: OnboardingPresentationLogic?
    var router: OnboardingRouting?

    private let completeOnboardingUseCase: CompleteOnboardingUseCase

    init(completeOnboardingUseCase: CompleteOnboardingUseCase) {
        self.completeOnboardingUseCase = completeOnboardingUseCase
    }

    func loadOnboarding() {
        presenter?.presentPages()
    }

    func skip() {
        completeOnboarding()
    }

    func finish() {
        completeOnboarding()
    }

    private func completeOnboarding() {
        completeOnboardingUseCase.complete(.init())
        router?.showMainApp()
    }
}
