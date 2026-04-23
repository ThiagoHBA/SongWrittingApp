import Foundation
import XCTest
import Networking
@testable import Main

final class LastFMReferenceSearchNetworkClientIntegrationTests: XCTestCase {

    override func tearDown() {
        super.tearDown()
        URLProtocolStub.reset()
    }

    func test_searchReferences_succeedsWithNetworkClientResponse() {
        let payload = """
        {
          "results": {
            "opensearch:totalResults": "21",
            "opensearch:startIndex": "0",
            "albummatches": {
              "album": [
                {
                  "name": "Like a Clockwork",
                  "artist": "Queens Of The Stone Age",
                  "image": [
                    { "#text": "" },
                    { "#text": "https://example.com/cover.jpg" }
                  ]
                }
              ]
            }
          }
        }
        """.data(using: .utf8)!
        let url = URL(string: "https://ws.audioscrobbler.com/2.0/")!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let (sut, protocolStub) = makeSUT(data: payload, response: response, error: nil)
        let exp = expectation(description: "Wait for search")
        var receivedResult: Result<SearchReferencesUseCaseOutput, Error>?

        sut.search(.init(keywords: "like a clo", provider: .lastFM)) { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)

        XCTAssertEqual(protocolStub.receivedRequest?.httpMethod, "GET")
        XCTAssertEqual(protocolStub.receivedRequest?.url?.scheme, "https")
        XCTAssertEqual(protocolStub.receivedRequest?.url?.host, "ws.audioscrobbler.com")
        XCTAssertEqual(protocolStub.receivedRequest?.url?.path, "/2.0")
        XCTAssertEqual(
            protocolStub.receivedRequest?.url?.queryItems,
            [
                URLQueryItem(name: "method", value: "album.search"),
                URLQueryItem(name: "album", value: "like a clo"),
                URLQueryItem(name: "api_key", value: LastFMReferencesConstants.apiKey),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "page", value: "1")
            ]
        )
        XCTAssertEqual(
            try? receivedResult?.get(),
            SearchReferencesPage(
                references: [
                    AlbumReference(
                        name: "Like a Clockwork",
                        artist: "Queens Of The Stone Age",
                        releaseDate: "",
                        coverImage: "https://example.com/cover.jpg"
                    )
                ],
                hasMore: true
            )
        )
    }
}

private extension LastFMReferenceSearchNetworkClientIntegrationTests {
    func makeSUT(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> (sut: LastFMReferenceSearchRepository, protocolStub: URLProtocolStub.Type) {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let networkClient = NetworkClientImpl(session: session)
        let sut = LastFMReferenceSearchRepository(networkClient: networkClient)
        return (sut, URLProtocolStub.self)
    }
}
