import Foundation

struct CreateNewDiscoUseCaseInput: Equatable {
    let name: String
    let image: Data
}

typealias CreateNewDiscoUseCaseOutput = DiscoSummary

protocol CreateNewDiscoUseCase {
    func create(
        _ input: CreateNewDiscoUseCaseInput,
        completion: @escaping (Result<CreateNewDiscoUseCaseOutput, Error>) -> Void
    )
}
