import Foundation

final class DiscoListContainer {
    let app: AppContainer

    init(app: AppContainer) {
        self.app = app
    }

    lazy var repository: DiscoListRepository = {
        DiscoListRepositoryImpl(store: app.discoStore)
    }()

    lazy var discoProfileContainer = DiscoProfileContainer(app: app)

    lazy var deleteDiscoUseCase: DeleteDiscoUseCase = {
        discoProfileContainer.repository
    }()
}
