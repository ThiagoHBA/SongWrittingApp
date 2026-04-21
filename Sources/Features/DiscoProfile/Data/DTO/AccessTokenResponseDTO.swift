import Foundation

struct AccessTokenResponseDTO: StoreRecord, Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int

    var authorizationHeader: String {
        "\(tokenType) \(accessToken)"
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
