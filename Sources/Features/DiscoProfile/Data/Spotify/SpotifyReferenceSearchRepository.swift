import Foundation

enum SpotifyReferencesConstants {
    static let baseURL = "api.spotify.com"
    static let accountURL = "accounts.spotify.com"
    static let secureStorageServer = "accounts.spotify.com"
    static let clientID = "99253a753ea749a5a8a2d1294871fe6c"
    static let clientSecret = "1f2801485f064781b3f94a38c393469c"
}

final class SpotifyReferenceSearchRepository: ReferenceSearchRepository {
    struct SpotifyReferenceSearchSession {
        let keywords: String
        let pageSize: Int
        let nextOffset: Int
        let hasMore: Bool
    }

    private let networkClient: NetworkClient
    private var session: SpotifyReferenceSearchSession?
    private var activeRequestID: UUID?

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func search(
        _ input: SearchReferencesUseCaseInput,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        session = .init(
            keywords: input.keywords,
            pageSize: 10,
            nextOffset: 0,
            hasMore: false
        )

        requestPage(offset: 0, completion: completion)
    }

    func loadMore(
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        guard let session else {
            completion(.failure(SearchReferencesUseCaseError.noActiveSearchSession))
            return
        }

        guard session.hasMore else {
            completion(.success(.init(references: [], hasMore: false)))
            return
        }

        requestPage(offset: session.nextOffset, completion: completion)
    }

    func reset() {
        session = nil
        activeRequestID = nil
    }

    private func requestPage(
        offset: Int,
        completion: @escaping (Result<SearchReferencesUseCaseOutput, Error>) -> Void
    ) {
        guard let session else {
            completion(.failure(SearchReferencesUseCaseError.noActiveSearchSession))
            return
        }

        let endpoint = GetReferencesEndpoint(
            keywords: session.keywords,
            limit: session.pageSize,
            offset: offset
        )
        let requestID = UUID()
        activeRequestID = requestID

        networkClient.makeRequest(endpoint) { [weak self] result in
            guard let self,
                  self.activeRequestID == requestID else {
                return
            }

            switch result {
            case .success(let data):
                do {
                    let dto = try AlbumReferenceDTO.loadFromData(data)
                    let references = dto.mapReferences()
                    let hasMore = dto.albums.offset + references.count < dto.albums.total

                    self.activeRequestID = nil
                    self.session = SpotifyReferenceSearchSession(
                        keywords: session.keywords,
                        pageSize: session.pageSize,
                        nextOffset: dto.albums.offset + references.count,
                        hasMore: hasMore
                    )

                    completion(.success(.init(references: references, hasMore: hasMore)))
                } catch {
                    self.activeRequestID = nil
                    completion(.failure(NetworkError.decodingError))
                }
            case .failure(let error):
                self.activeRequestID = nil
                completion(.failure(error))
            }
        }
    }
}
