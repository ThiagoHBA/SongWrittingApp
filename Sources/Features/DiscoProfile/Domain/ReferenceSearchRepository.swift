import Foundation

protocol ReferenceSearchRepository {
    func searchReferences(
        matching keywords: String,
        completion: @escaping (Result<[AlbumReference], Error>) -> Void
    )
}
