import Foundation

protocol DiscoListRepository {
    func getDiscos(completion: @escaping (Result<[DiscoSummary], Error>) -> Void)
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
