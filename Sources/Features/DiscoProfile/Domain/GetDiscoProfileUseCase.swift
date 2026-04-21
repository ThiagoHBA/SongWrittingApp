import Foundation

typealias GetDiscoProfileUseCaseInput = DiscoSummary
typealias GetDiscoProfileUseCaseOutput = DiscoProfile

protocol GetDiscoProfileUseCase {
    func load(
        _ input: GetDiscoProfileUseCaseInput,
        completion: @escaping (Result<GetDiscoProfileUseCaseOutput, Error>) -> Void
    )
}
