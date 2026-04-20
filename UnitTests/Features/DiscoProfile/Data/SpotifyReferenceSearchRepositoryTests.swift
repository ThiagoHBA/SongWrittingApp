import Foundation
import XCTest
@testable import Main

final class SpotifyReferenceSearchRepositoryTests: XCTestCase {
    func test_searchReferences_uses_network_client_and_starts_session() throws {
        let (sut, networkClient) = makeSUT()
        let payload = try JSONEncoder().encode(makeDTO(offset: 0, total: 21))
        var receivedResult: SearchReferencesUseCaseOutput?

        sut.search(.init(keywords: "any request")) { result in
            if case let .success(output) = result {
                receivedResult = output
            }
        }

        networkClient.makeRequestCompletion?(.success(payload))

        XCTAssertEqual(networkClient.makeRequestCalled, 1)
        XCTAssertEqual(
            networkClient.receivedEndpointQueries,
            [
                URLQueryItem(name: "q", value: "any request"),
                URLQueryItem(name: "type", value: "album"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "offset", value: "0")
            ]
        )
        XCTAssertEqual(
            receivedResult,
            SearchReferencesPage(
                references: [
                    AlbumReference(
                        name: "Album",
                        artist: "Artist",
                        releaseDate: "2024-01-01",
                        coverImage: "https://example.com/image"
                    )
                ],
                hasMore: true
            )
        )
    }

    func test_loadMoreReferences_uses_stored_session_offset() throws {
        let (sut, networkClient) = makeSUT()
        let firstPayload = try JSONEncoder().encode(makeDTO(offset: 0, total: 21))
        let secondPayload = try JSONEncoder().encode(makeDTO(offset: 1, total: 21))

        sut.search(.init(keywords: "any request")) { _ in }
        networkClient.makeRequestCompletion?(.success(firstPayload))
        sut.loadMore { _ in }

        XCTAssertEqual(
            networkClient.receivedEndpointQueries,
            [
                URLQueryItem(name: "q", value: "any request"),
                URLQueryItem(name: "type", value: "album"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "offset", value: "1")
            ]
        )

        networkClient.makeRequestCompletion?(.success(secondPayload))
    }

    func test_loadMoreReferences_fails_without_active_session() {
        let (sut, _) = makeSUT()
        var receivedError: SearchReferencesUseCaseError?

        sut.loadMore { result in
            if case let .failure(error as SearchReferencesUseCaseError) = result {
                receivedError = error
            }
        }

        XCTAssertEqual(receivedError, .noActiveSearchSession)
    }

    func test_reset_clears_session_for_loadMore() {
        let (sut, _) = makeSUT()
        var receivedError: SearchReferencesUseCaseError?

        sut.search(.init(keywords: "any request")) { _ in }
        sut.reset()
        sut.loadMore { result in
            if case let .failure(error as SearchReferencesUseCaseError) = result {
                receivedError = error
            }
        }

        XCTAssertEqual(receivedError, .noActiveSearchSession)
    }

    func test_newSearch_ignores_stale_completion_from_previous_session() throws {
        let (sut, networkClient) = makeSUT()
        let oldPayload = try JSONEncoder().encode(makeDTO(offset: 0, total: 21))
        let newPayload = try JSONEncoder().encode(makeDTO(offset: 0, total: 21))

        sut.search(.init(keywords: "old request")) { _ in }
        sut.search(.init(keywords: "new request")) { _ in }
        networkClient.completeRequest(at: 0, with: .success(oldPayload))
        networkClient.completeRequest(at: 1, with: .success(newPayload))

        sut.loadMore { _ in }

        XCTAssertEqual(
            networkClient.receivedEndpointQueries,
            [
                URLQueryItem(name: "q", value: "new request"),
                URLQueryItem(name: "type", value: "album"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "offset", value: "1")
            ]
        )
    }

    func test_searchReferences_returns_decoding_error_for_invalid_payload() {
        let (sut, networkClient) = makeSUT()
        var receivedError: Error?

        sut.search(.init(keywords: "any request")) { result in
            if case let .failure(error) = result {
                receivedError = error
            }
        }

        networkClient.makeRequestCompletion?(.success(Data()))

        XCTAssertEqual(receivedError as? NetworkError, .decodingError)
    }

    func test_searchReferences_propagates_network_failure() {
        let (sut, networkClient) = makeSUT()
        let expectedError = NSError(domain: "network", code: 0)
        var receivedError: NSError?

        sut.search(.init(keywords: "any request")) { result in
            if case let .failure(error as NSError) = result {
                receivedError = error
            }
        }

        networkClient.makeRequestCompletion?(.failure(expectedError))

        XCTAssertEqual(receivedError, expectedError)
    }

    private func makeSUT() -> (sut: SpotifyReferenceSearchRepository, networkClient: NetworkClientSpy) {
        let networkClient = NetworkClientSpy()
        let sut = SpotifyReferenceSearchRepository(networkClient: networkClient)
        return (sut, networkClient)
    }

    private func makeDTO(offset: Int = 20, total: Int = 21) -> AlbumReferenceDTO {
        AlbumReferenceDTO(
            albums: Albums(
                items: [
                    AlbumItem(
                        artists: [AlbumArtist(name: "Artist")],
                        images: [AlbumImage(height: 1, url: "https://example.com/image", width: 1)],
                        name: "Album",
                        releaseDate: "2024-01-01"
                    )
                ],
                limit: 10,
                offset: offset,
                total: total
            )
        )
    }
}

private final class NetworkClientSpy: NetworkClient {
    private(set) var makeRequestCalled = 0
    private(set) var receivedEndpointQueries: [URLQueryItem] = []
    private var completions: [(Result<Data, Error>) -> Void] = []
    var makeRequestCompletion: ((Result<Data, Error>) -> Void)? {
        completions.last
    }

    func makeRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        makeRequestCalled += 1
        receivedEndpointQueries = endpoint.queries
        completions.append(completion)
    }

    func completeRequest(at index: Int = 0, with result: Result<Data, Error>) {
        completions[index](result)
    }
}
