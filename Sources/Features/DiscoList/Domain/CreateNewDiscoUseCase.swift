import Foundation

typealias CreateNewDiscoUseCaseInput = Disco
typealias CreateNewDiscoUseCaseOutput = DiscoSummary

protocol CreateNewDiscoUseCase {
    func create(
        _ input: CreateNewDiscoUseCaseInput,
        completion: @escaping (Result<CreateNewDiscoUseCaseOutput, Error>) -> Void
    )
}
