import Foundation

struct GetReferencesEndpoint: Endpoint {
    var headers: [String: String]
    var body: Data?
    var httpMethod: HTTPMethod? = .get
    var communicationProtocol: CommunicationProtocol = .HTTPS

    var urlBase: String {
        SpotifyReferencesConstants.baseURL
    }

    var path: String {
        "/v1/search/"
    }

    var queries: [URLQueryItem]

    init(
        keywords: String,
        limit: Int,
        offset: Int,
        headers: [String: String] = [:]
    ) {
        self.queries = [
            .init(name: "q", value: keywords),
            .init(name: "type", value: "album"),
            .init(name: "limit", value: "\(limit)"),
            .init(name: "offset", value: "\(offset)")
        ]
        self.headers = headers
    }
}
