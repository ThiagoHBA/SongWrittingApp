import Foundation

final class AuthorizationHandlerImpl: AuthorizationHandler {
    private let networkClient: NetworkClient
    private let secureClient: SecureClient

    init(networkClient: NetworkClient, secureClient: SecureClient) {
        self.networkClient = networkClient
        self.secureClient = secureClient
    }

    func loadToken(
        completion: @escaping (Result<AccessTokenResponseDTO, TokenError>) -> Void
    ) {
        if let cachedToken = getCachedToken() {
            completion(.success(cachedToken))
            return
        }

        let authString = "\(SpotifyReferencesConstants.clientID):\(SpotifyReferencesConstants.clientSecret)"
        guard let authBytes = authString.data(using: .utf8) else {
            completion(.failure(.unableToCreateToken))
            return
        }

        let authBase64 = authBytes.base64EncodedString()
        let endpoint = LoadTokenEndpoint(
            headers: [
                "Authorization": "Basic \(authBase64)",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        )

        networkClient.makeRequest(endpoint) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let data):
                do {
                    try self.secureClient.saveData(data)
                    let token = try AccessTokenResponseDTO.loadFromData(data)
                    completion(.success(token))
                } catch {
                    completion(.failure(.unableToCreateToken))
                }
            case .failure(let error):
                completion(.failure(.requestError(error)))
            }
        }
    }

    func clearCachedTokenIfExists() {
        if getCachedToken() != nil {
            try? secureClient.deleteData()
        }
    }

    private func getCachedToken() -> AccessTokenResponseDTO? {
        guard let tokenData = try? secureClient.getData() else { return nil }
        return try? AccessTokenResponseDTO.loadFromData(tokenData)
    }
}
