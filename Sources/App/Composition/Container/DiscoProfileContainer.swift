import Foundation
import Networking

final class DiscoProfileContainer {
    let app: AppContainer

    init(app: AppContainer) {
        self.app = app
    }

    lazy var repository: DiscoProfileRepository = {
        DiscoProfileRepositoryImpl(
            store: app.discoStore,
            fileManagerService: app.fileManagerService
        )
    }()

    lazy var spotifyAuthorizationHandler: SpotifyAuthorizationHandler = {
        SpotifyAuthorizationHandlerImpl(
            networkClient: app.networkClient,
            secureClient: app.secureClient
        )
    }()

    lazy var authorizedNetworkClient: NetworkClient = {
        AuthorizationDecorator(
            client: app.networkClient,
            tokenProvider: spotifyAuthorizationHandler
        )
    }()

    lazy var referenceSearchRepository: ReferenceSearchRepository = {
        ReferenceSearchStrategyRegistry(
            spotify: SpotifyReferenceSearchRepository(networkClient: authorizedNetworkClient),
            lastFM: LastFMReferenceSearchRepository(networkClient: app.networkClient)
        )
    }()
}
