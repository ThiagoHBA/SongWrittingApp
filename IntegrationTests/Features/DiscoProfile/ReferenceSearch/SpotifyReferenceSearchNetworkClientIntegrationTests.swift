import Foundation
import XCTest
@testable import Main

final class SpotifyReferenceSearchNetworkClientIntegrationTests: XCTestCase {

    override func tearDown() {
        super.tearDown()
        URLProtocolStub.reset()
    }

    func test_searchReferences_succeedsWithNetworkClientResponse() {
        let payload = """
        {
          "albums": {
            "items": [
              {
                "artists": [
                  { "name": "Queens Of The Stone Age" }
                ],
                "images": [
                  {
                    "height": 640,
                    "url": "https://example.com/cover.jpg",
                    "width": 640
                  }
                ],
                "name": "Like Clockwork",
                "release_date": "2013-06-03"
              }
            ],
            "limit": 10,
            "offset": 0,
            "total": 21
          }
        }
        """.data(using: .utf8)!
        let url = URL(string: "https://api.spotify.com/v1/search/")!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let (sut, protocolStub) = makeSUT(data: payload, response: response, error: nil)
        let exp = expectation(description: "Wait for search")
        var receivedResult: Result<SearchReferencesUseCaseOutput, Error>?

        sut.search(.init(keywords: "like a clo", provider: .spotify)) { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)

        XCTAssertEqual(protocolStub.receivedRequest?.httpMethod, "GET")
        XCTAssertEqual(protocolStub.receivedRequest?.url?.scheme, "https")
        XCTAssertEqual(protocolStub.receivedRequest?.url?.host, "api.spotify.com")
        XCTAssertEqual(protocolStub.receivedRequest?.url?.path, "/v1/search")
        XCTAssertEqual(
            protocolStub.receivedRequest?.url?.queryItems,
            [
                URLQueryItem(name: "q", value: "like a clo"),
                URLQueryItem(name: "type", value: "album"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "offset", value: "0")
            ]
        )
        XCTAssertEqual(
            try? receivedResult?.get(),
            SearchReferencesPage(
                references: [
                    AlbumReference(
                        name: "Like Clockwork",
                        artist: "Queens Of The Stone Age",
                        releaseDate: "2013-06-03",
                        coverImage: "https://example.com/cover.jpg"
                    )
                ],
                hasMore: true
            )
        )
    }
}

private extension SpotifyReferenceSearchNetworkClientIntegrationTests {
    func makeSUT(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> (sut: SpotifyReferenceSearchRepository, protocolStub: URLProtocolStub.Type) {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let networkClient = NetworkClientImpl(session: session)
        let sut = SpotifyReferenceSearchRepository(networkClient: networkClient)
        return (sut, URLProtocolStub.self)
    }
}
