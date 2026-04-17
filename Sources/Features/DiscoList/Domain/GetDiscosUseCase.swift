import Foundation

struct GetDiscosUseCaseInput: Equatable {}

typealias GetDiscosUseCaseOutput = [DiscoSummary]

protocol GetDiscosUseCase {
    func load(
        _ input: GetDiscosUseCaseInput,
        completion: @escaping (Result<GetDiscosUseCaseOutput, Error>) -> Void
    )
}
