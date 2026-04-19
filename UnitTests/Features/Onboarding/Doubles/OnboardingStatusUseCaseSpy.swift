import Foundation
@testable import Main

final class OnboardingStatusUseCaseSpy: GetOnboardingStatusUseCase, CompleteOnboardingUseCase {
    private(set) var loadCallCount = 0
    private(set) var receivedLoadInputs: [GetOnboardingStatusUseCaseInput] = []
    private(set) var completeCallCount = 0
    private(set) var receivedCompleteInputs: [CompleteOnboardingUseCaseInput] = []
    var loadResult = false

    func load(_ input: GetOnboardingStatusUseCaseInput) -> GetOnboardingStatusUseCaseOutput {
        loadCallCount += 1
        receivedLoadInputs.append(input)
        return loadResult
    }

    func complete(_ input: CompleteOnboardingUseCaseInput) {
        completeCallCount += 1
        receivedCompleteInputs.append(input)
    }
}
