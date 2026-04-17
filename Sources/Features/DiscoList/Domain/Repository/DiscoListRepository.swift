import Foundation

protocol DiscoListRepository: GetDiscosUseCase {
    func createDisco(
        name: String,
        image: Data,
        completion: @escaping (Result<DiscoSummary, Error>) -> Void
    )
    func deleteDisco(
        _ disco: DiscoSummary,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
