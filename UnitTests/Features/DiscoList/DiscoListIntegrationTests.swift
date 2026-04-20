import XCTest
@testable import Main

final class DiscoListIntegrationTests: XCTestCase {
    
    func test_loadDiscos_shouldSucceed_whenStoreHasDiscos() {
        let (sut, presenter, store) = makeSUT()
        let discoRecord = DiscoStoreRecord(id: UUID(), name: "Test Disco", description: "Test Description", coverImage: Data("image".utf8))
        
        store.createDisco(discoRecord) { _ in }
        
        sut.loadDiscos()
        
        XCTAssertEqual(presenter.receivedMessages, [.presentLoading, .presentLoadedDiscos([DiscoSummary(id: discoRecord.id, name: "Test Disco", coverImage: discoRecord.coverImage)])])
    }
    
    func test_createDisco_shouldSucceed_whenNameIsUnique() {
        let (sut, presenter, store) = makeSUT()
        let name = "New Disco"
        let image = Data("new image".utf8)
        
        sut.createDisco(name: name, description: "New Description", image: image)
        
        // Assert on store directly to ensure persistence
        store.getDiscos { result in
            if case let .success(discos) = result {
                XCTAssertEqual(discos.count, 1)
                XCTAssertEqual(discos.first?.name, name)
            } else {
                XCTFail("Should have fetched discos")
            }
        }
        
        // Assert on presenter to ensure UI logic was triggered
        XCTAssertEqual(presenter.receivedMessages.count, 2)
        XCTAssertEqual(presenter.receivedMessages[0], .presentLoading)
        if case let .presentCreatedDisco(disco) = presenter.receivedMessages[1] {
            XCTAssertEqual(disco.name, name)
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
        
        XCTAssertEqual(presenter.receivedMessages, [
            .presentLoading,
            .presentCreateDiscoFailure("Um disco com o mesmo nome já foi criado")
        ])
    }
}

extension DiscoListIntegrationTests {
    private func makeSUT() -> (sut: DiscoListInteractor, presenter: DiscoListPresenterSpy, store: DiscoStore) {
        let database = InMemoryDatabase() // Fresh database for each test
        let store = InMemoryDiscoStore(database: database)
        let repository = DiscoListRepositoryImpl(store: store)
        let presenter = DiscoListPresenterSpy()
        let sut = DiscoListInteractor(
            getDiscosUseCase: repository,
            createNewDiscoUseCase: repository
        )
        sut.presenter = presenter
        return (sut, presenter, store)
    }
}
