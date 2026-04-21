import Foundation

enum DiscoCrashlyticsEvent {
    case creationFailure
    case deletionFailure

    var message: String {
        switch self {
        case .creationFailure:
            return "Disco Creation Failure"
        case .deletionFailure:
            return "Disco Deletion Failure"
        }
    }

    var errorKey: String {
        switch self {
        case .creationFailure:
            return "disco_creation_error"
        case .deletionFailure:
            return "disco_deletion_error"
        }
    }
}

enum DiscoAnalyticsEvent: String {
    case creationSuccess = "disco_creation_success"
    case deletionSuccess = "disco_deletion_success"
}

final class DiscoObservabilityDecorator {
    private let createUseCase: CreateNewDiscoUseCase
    private let deleteUseCase: DeleteDiscoUseCase
    private let crashReporter: CrashReporting
    private let analyticsReporter: AnalyticsReporting

    init(
        createUseCase: CreateNewDiscoUseCase,
        deleteUseCase: DeleteDiscoUseCase,
        crashReporter: CrashReporting,
        analyticsReporter: AnalyticsReporting
    ) {
        self.createUseCase = createUseCase
        self.deleteUseCase = deleteUseCase
        self.crashReporter = crashReporter
        self.analyticsReporter = analyticsReporter
    }
}

extension DiscoObservabilityDecorator: CreateNewDiscoUseCase {
    func create(
        _ input: CreateNewDiscoUseCaseInput,
        completion: @escaping (Result<CreateNewDiscoUseCaseOutput, Error>) -> Void
    ) {
        createUseCase.create(input) { [crashReporter, analyticsReporter] result in
            switch result {
            case .success:
                analyticsReporter.logEvent(DiscoAnalyticsEvent.creationSuccess.rawValue, parameters: nil)
            case .failure(let error):
                let event = DiscoCrashlyticsEvent.creationFailure
                crashReporter.log(event.message)
                crashReporter.setValue(error.localizedDescription, forKey: event.errorKey)
            }

            completion(result)
        }
    }
}

extension DiscoObservabilityDecorator: DeleteDiscoUseCase {
    func delete(
        _ input: DeleteDiscoUseCaseInput,
        completion: @escaping (Result<DeleteDiscoUseCaseOutput, Error>) -> Void
    ) {
        deleteUseCase.delete(input) { [crashReporter, analyticsReporter] result in
            switch result {
            case .success:
                analyticsReporter.logEvent(DiscoAnalyticsEvent.deletionSuccess.rawValue, parameters: nil)
            case .failure(let error):
                let event = DiscoCrashlyticsEvent.deletionFailure
                crashReporter.log(event.message)
                crashReporter.setValue(error.localizedDescription, forKey: event.errorKey)
            }

            completion(result)
        }
    }
}
