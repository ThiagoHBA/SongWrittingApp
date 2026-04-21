import Foundation

struct CompleteOnboardingUseCaseInput: Equatable {}

protocol CompleteOnboardingUseCase {
    func complete(_ input: CompleteOnboardingUseCaseInput)
}
