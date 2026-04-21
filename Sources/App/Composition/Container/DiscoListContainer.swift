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

    lazy var createNewDiscoUseCase: CreateNewDiscoUseCase = {
        observabilityDecorator
    }()

    lazy var deleteDiscoUseCase: DeleteDiscoUseCase = {
        observabilityDecorator
    }()

    lazy var getDiscoReferencesUseCase: GetDiscoReferencesUseCase = {
        discoProfileContainer.repository
    }()

    private lazy var observabilityDecorator = DiscoObservabilityDecorator(
        createUseCase: repository,
        deleteUseCase: discoProfileContainer.repository,
        crashReporter: app.crashReporter,
        analyticsReporter: app.analyticsReporter
    )
}
