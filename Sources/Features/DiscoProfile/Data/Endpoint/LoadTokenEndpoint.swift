import Foundation
import Networking

struct LoadTokenEndpoint: Endpoint {
    var body: Data?
    var httpMethod: HTTPMethod? = .post
    var communicationProtocol: CommunicationProtocol = .HTTPS
    var headers: [String: String]

    var urlBase: String {
        SpotifyReferencesConstants.accountURL
    }

    var path: String {
        "/api/token"
    }

    init(headers: [String: String]) {
        self.headers = headers
        self.body = "grant_type=client_credentials".data(using: .utf8)
    }
}
