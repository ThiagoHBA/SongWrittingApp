import Foundation

enum TokenError: LocalizedError {
    case unableToCreateToken
    case requestError(Error)

    var errorDescription: String? {
        "Não foi possível realizar a autenticação com o servidor, reinicie o aplicativo e tente novamente!"
    }
}

protocol AuthorizationHandler: AuthorizationTokenProvider {
    func loadToken(
        completion: @escaping (Result<AccessTokenResponseDTO, TokenError>) -> Void
    )
}

extension AuthorizationHandler {
    func loadAuthorizationValue(
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        loadToken { result in
            switch result {
            case .success(let token):
                completion(.success(token.authorizationHeader))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
