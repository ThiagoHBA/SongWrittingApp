import Foundation
import XCTest
@testable import Main

final class SpotifyReferenceSearchRepositoryTests: XCTestCase {
    func test_searchReferences_uses_network_client() throws {
        let (sut, networkClient) = makeSUT()
        let payload = try JSONEncoder().encode(
            AlbumReferenceDTO(
                albums: Albums(
                    items: [
                        AlbumItem(
                            artists: [AlbumArtist(name: "Artist")],
                            images: [AlbumImage(height: 1, url: "https://example.com/image", width: 1)],
                            name: "Album",
                            releaseDate: "2024-01-01"
                        )
                    ]
                )
            )
        )
        var receivedReferences: [AlbumReference] = []

        sut.searchReferences(matching: "any request") { result in
            if case let .success(references) = result {
                receivedReferences = references
            }
        }

        networkClient.makeRequestCompletion?(.success(payload))

        XCTAssertEqual(networkClient.makeRequestCalled, 1)
        XCTAssertEqual(
            receivedReferences,
            [
                AlbumReference(
                    name: "Album",
                    artist: "Artist",
                    releaseDate: "2024-01-01",
                    coverImage: "https://example.com/image"
                )
            ]
        )
    }

    func test_searchReferences_returns_decoding_error_for_invalid_payload() {
        let (sut, networkClient) = makeSUT()
        var receivedError: Error?

        sut.searchReferences(matching: "any request") { result in
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

        sut.searchReferences(matching: "any request") { result in
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
}

private final class NetworkClientSpy: NetworkClient {
    private(set) var makeRequestCalled = 0
    var makeRequestCompletion: ((Result<Data, Error>) -> Void)?

    func makeRequest(
        _ endpoint: Endpoint,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        makeRequestCalled += 1
        makeRequestCompletion = completion
    }
}
