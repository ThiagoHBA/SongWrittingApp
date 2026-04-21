import XCTest
@testable import Main

final class AppContainerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        AppContainer.setShared(makeInMemoryContainer())
    }

    func test_setShared_replacesSharedInstance() {
        let container = makeInMemoryContainer()

        AppContainer.setShared(container)

        XCTAssertTrue(AppContainer.shared === container)
    }

    func test_init_inMemory_createsExpectedDependencies() {
        let sut = makeInMemoryContainer()

        XCTAssertTrue(sut.discoStore is InMemoryDiscoStore)
        XCTAssertTrue(sut.userDefaultsClient is UserDefaultsClientImpl)
        XCTAssertTrue(sut.fileManagerService is FileManagerServiceImpl)
        XCTAssertTrue(sut.networkClient is NetworkClientImpl)
        XCTAssertTrue(sut.secureClient is SecureClientImpl)
        XCTAssertTrue(sut.analyticsReporter is NoOpAnalyticsReporter)
    }

    func test_featureContainers_buildExpectedDependenciesFromRootContainer() {
        let app = makeInMemoryContainer()

        let onboardingContainer = OnboardingContainer(app: app)
        let discoListContainer = DiscoListContainer(app: app)
        let discoProfileContainer = DiscoProfileContainer(app: app)

        XCTAssertTrue(onboardingContainer.onboardingStatusRepository is UserDefaultsOnboardingStatusRepository)
        XCTAssertTrue(discoListContainer.repository is DiscoListRepositoryImpl)
        XCTAssertTrue(discoListContainer.createNewDiscoUseCase is DiscoObservabilityDecorator)
        XCTAssertTrue(discoListContainer.deleteDiscoUseCase is DiscoObservabilityDecorator)
        XCTAssertTrue(discoProfileContainer.repository is DiscoProfileRepositoryImpl)
        XCTAssertTrue(discoListContainer.discoProfileContainer.repository is DiscoProfileRepositoryImpl)
        XCTAssertTrue(discoProfileContainer.spotifyAuthorizationHandler is SpotifyAuthorizationHandlerImpl)
        XCTAssertTrue(discoProfileContainer.referenceSearchRepository is ReferenceSearchStrategyRegistry)
    }

    private func makeInMemoryContainer() -> AppContainer {
        try! AppContainer(storage: .inMemory())
    }
}
