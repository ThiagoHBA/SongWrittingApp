//
//  LastFMReferenceSearchRepositoryTests.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation
import XCTest
@testable import Main

final class LastFMReferenceSearchRepositoryTests: XCTestCase {
    func test_searchReferences_uses_network_client_and_starts_session() throws {
        let (sut, networkClient) = makeSUT()
        let payload = try JSONEncoder().encode(makeDTO(startIndex: 0, totalResults: 21))
        var receivedResult: SearchReferencesUseCaseOutput?

        sut.search(.init(keywords: "any request",  provider: .lastFM)) { result in
            if case let .success(output) = result {
                receivedResult = output
            }
        }

        networkClient.makeRequestCompletion?(.success(payload))

        XCTAssertEqual(networkClient.makeRequestCalled, 1)
        XCTAssertEqual(
            networkClient.receivedEndpointQueries,
            [
                URLQueryItem(name: "method", value: "album.search"),
                URLQueryItem(name: "album", value: "any request"),
                URLQueryItem(name: "api_key", value: LastFMReferencesConstants.apiKey),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
        XCTAssertEqual(
            receivedResult,
            SearchReferencesPage(
                references: [
                    AlbumReference(
                        name: "Album",
                        artist: "Artist",
                        releaseDate: "",
                        coverImage: "https://example.com/image-large"
                    )
                ],
                hasMore: true
            )
        )
    }

    func test_loadMoreReferences_uses_stored_session_page() throws {
        let (sut, networkClient) = makeSUT()
        let firstPayload = try JSONEncoder().encode(makeDTO(startIndex: 0, totalResults: 21))
        let secondPayload = try JSONEncoder().encode(makeDTO(startIndex: 10, totalResults: 21))

        sut.search(.init(keywords: "any request",  provider: .lastFM)) { _ in }
        networkClient.makeRequestCompletion?(.success(firstPayload))
        sut.loadMore { _ in }

        XCTAssertEqual(
            networkClient.receivedEndpointQueries,
            [
                URLQueryItem(name: "method", value: "album.search"),
                URLQueryItem(name: "album", value: "any request"),
                URLQueryItem(name: "api_key", value: LastFMReferencesConstants.apiKey),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "page", value: "2")
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

        sut.search(.init(keywords: "any request",  provider: .lastFM)) { _ in }
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
        let oldPayload = try JSONEncoder().encode(makeDTO(startIndex: 0, totalResults: 21))
        let newPayload = try JSONEncoder().encode(makeDTO(startIndex: 0, totalResults: 21))

        sut.search(.init(keywords: "old request",  provider: .lastFM)) { _ in }
        sut.search(.init(keywords: "new request",  provider: .lastFM)) { _ in }
        networkClient.completeRequest(at: 0, with: .success(oldPayload))
        networkClient.completeRequest(at: 1, with: .success(newPayload))

        sut.loadMore { _ in }

        XCTAssertEqual(
            networkClient.receivedEndpointQueries,
            [
                URLQueryItem(name: "method", value: "album.search"),
                URLQueryItem(name: "album", value: "new request"),
                URLQueryItem(name: "api_key", value: LastFMReferencesConstants.apiKey),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "page", value: "2")
            ]
        )
    }

    func test_searchReferences_returns_decoding_error_for_invalid_payload() {
        let (sut, networkClient) = makeSUT()
        var receivedError: Error?

        sut.search(.init(keywords: "any request",  provider: .lastFM)) { result in
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

        sut.search(.init(keywords: "any request",  provider: .lastFM)) { result in
            if case let .failure(error as NSError) = result {
                receivedError = error
            }
        }

        networkClient.makeRequestCompletion?(.failure(expectedError))

        XCTAssertEqual(receivedError, expectedError)
    }

    private func makeSUT() -> (sut: LastFMReferenceSearchRepository, networkClient: NetworkClientSpy) {
        let networkClient = NetworkClientSpy()
        let sut = LastFMReferenceSearchRepository(networkClient: networkClient)
        return (sut, networkClient)
    }

    private func makeDTO(startIndex: Int = 20, totalResults: Int = 21) -> LastFMAlbumReferenceDTO {
        LastFMAlbumReferenceDTO(
            results: LastFMAlbumSearchResultsDTO(
                albumMatches: LastFMAlbumMatchesDTO(
                    albums: [
                        LastFMAlbumMatchDTO(
                            name: "Album",
                            artist: "Artist",
                            images: [
                                LastFMAlbumImageDTO(text: ""),
                                LastFMAlbumImageDTO(text: "https://example.com/image-large")
                            ]
                        )
                    ]
                ),
                totalResultsValue: "\(totalResults)",
                startIndexValue: "\(startIndex)"
            )
        )
    }
}
