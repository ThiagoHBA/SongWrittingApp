import XCTest
@testable import Main

final class DiscoListIntegrationTests: XCTestCase {

    func test_loadDiscos_shouldSucceed_whenStoreHasDiscos() {
        let (sut, presenter, store) = makeSUT()
        let discoRecord = DiscoStoreRecord(id: UUID(), name: "Test Disco", description: "Test Description", coverImage: Data("image".utf8))

        store.createDisco(discoRecord) { _ in }
        sut.loadDiscos()

        wait(until: { presenter.receivedMessages.count == 2 })
        XCTAssertEqual(presenter.receivedMessages, [
            .presentLoading,
            .presentLoadedDiscos([
                (
                    disco: DiscoSummary(
                        id: discoRecord.id,
                        name: "Test Disco",
                        description: "Test Description",
                        coverImage: discoRecord.coverImage
                    ),
                    references: [AlbumReference]()
                )
            ])
        ])
    }

    func test_createDisco_shouldSucceed_whenNameIsUnique() {
        let (sut, presenter, store) = makeSUT()
        let name = "New Disco"
        let description = "New Description"
        let image = Data("new image".utf8)

        sut.createDisco(name: name, description: description, image: image)

        let storeExpectation = expectation(description: "Wait for store fetch")
        store.getDiscos { result in
            if case let .success(discos) = result {
                XCTAssertEqual(discos.count, 1)
                XCTAssertEqual(discos.first?.name, name)
                XCTAssertEqual(discos.first?.description, description)
            } else {
                XCTFail("Should have fetched discos")
            }
            storeExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)

        XCTAssertEqual(presenter.receivedMessages.count, 2)
        XCTAssertEqual(presenter.receivedMessages[0], .presentLoading)
        if case let .presentCreatedDisco(disco) = presenter.receivedMessages[1] {
            XCTAssertEqual(disco.name, name)
            XCTAssertEqual(disco.description, description)
        } else {
            XCTFail("Should have presented created disco, got \(presenter.receivedMessages[1])")
        }
    }

    func test_createDisco_shouldFail_whenNameAlreadyExists() {
        let (sut, presenter, store) = makeSUT()
        let name = "Duplicate Disco"
        let image = Data("image".utf8)
        let existingDisco = DiscoStoreRecord(id: UUID(), name: name, description: nil, coverImage: image)

        store.createDisco(existingDisco) { _ in }
        sut.createDisco(name: name, description: nil, image: image)

        XCTAssertEqual(presenter.receivedMessages[0], .presentLoading)
        if case let .presentCreateDiscoFailure(message) = presenter.receivedMessages[1] {
            XCTAssertEqual(message, "Um disco com o mesmo nome já foi criado")
        } else {
            XCTFail("Expected presentCreateDiscoFailure, got \(presenter.receivedMessages[1])")
        }
    }
}

extension DiscoListIntegrationTests {
    private func makeSUT() -> (sut: DiscoListInteractor, presenter: DiscoListPresenterSpy, store: DiscoStore) {
        let database = InMemoryDatabase()
        let store = InMemoryDiscoStore(database: database)
        let repository = DiscoListRepositoryImpl(store: store)
        let discoProfileRepository = DiscoProfileRepositoryImpl(
            store: store,
            fileManagerService: FileManagerServiceImpl()
        )
        let presenter = DiscoListPresenterSpy()
        let sut = DiscoListInteractor(
            getDiscosUseCase: repository,
            createNewDiscoUseCase: repository,
            deleteDiscoUseCase: discoProfileRepository,
            getDiscoReferencesUseCase: discoProfileRepository
        )
        sut.presenter = presenter
        return (sut, presenter, store)
    }
}
