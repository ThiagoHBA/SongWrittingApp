import Foundation

final class SpotifyReferenceSearchRepository: ReferenceSearchRepository {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func searchReferences(
        matching keywords: String,
        completion: @escaping (Result<[AlbumReference], Error>) -> Void
    ) {
        let endpoint = GetReferencesEndpoint(keywords: keywords)

        networkClient.makeRequest(endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let dto = try AlbumReferenceDTO.loadFromData(data)
                    completion(.success(dto.toDomain()))
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
