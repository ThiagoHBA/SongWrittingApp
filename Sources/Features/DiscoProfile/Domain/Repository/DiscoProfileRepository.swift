import Foundation

protocol DiscoProfileRepository {
    func loadProfile(
        for disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    )

    func addReferences(
        _ references: [AlbumReference],
        to disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    )

    func addSection(
        _ section: Section,
        to disco: DiscoSummary,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    )

    func addRecord(
        in disco: DiscoSummary,
        to section: Section,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    )
}
