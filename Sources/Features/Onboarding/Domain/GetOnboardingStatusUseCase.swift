import Foundation

struct GetOnboardingStatusUseCaseInput: Equatable {}

typealias GetOnboardingStatusUseCaseOutput = Bool

protocol GetOnboardingStatusUseCase {
    func load(_ input: GetOnboardingStatusUseCaseInput) -> GetOnboardingStatusUseCaseOutput
}
