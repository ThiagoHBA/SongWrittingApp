import Foundation
import XCTest
@testable import Main

final class DiscoListRepositoryImplTests: XCTestCase {
    func test_getDiscos_fetches_from_store() {
        let (sut, store) = makeSUT()

        sut.getDiscos { _ in }
        store.getDiscosCompletion?(.success([]))

        XCTAssertEqual(store.receivedMessages, [.getDiscos])
    }

    func test_createDisco_fails_when_name_already_exists() {
        let (sut, store) = makeSUT()
        let expectedError = "Um disco com o mesmo nome já foi criado"
        let existingDisco = DiscoStoreRecord(id: UUID(), name: "Any", coverImage: Data())

        var receivedError: Error?
        sut.createDisco(name: "Any", image: Data("image".utf8)) { result in
            if case let .failure(error) = result {
                receivedError = error
            }
        }

        store.getDiscosCompletion?(.success([existingDisco]))

        XCTAssertEqual(store.receivedMessages, [.getDiscos])
        XCTAssertEqual(receivedError?.localizedDescription, expectedError)
    }

    func test_createDisco_creates_summary_when_name_is_unique() {
        let (sut, store) = makeSUT()
        let expectedImage = Data("cover".utf8)
        let createdRecord = DiscoStoreRecord(id: UUID(), name: "New", coverImage: expectedImage)

        var receivedDisco: DiscoSummary?
        sut.createDisco(name: "New", image: expectedImage) { result in
            if case let .success(disco) = result {
                receivedDisco = disco
            }
        }

        store.getDiscosCompletion?(.success([]))
        store.createDiscoCompletion?(.success(createdRecord))

        XCTAssertEqual(store.receivedMessages, [.getDiscos, .createDisco(createdRecord)])
        XCTAssertEqual(receivedDisco, DiscoSummary(id: createdRecord.id, name: "New", coverImage: expectedImage))
    }

    func test_deleteDisco_returns_migration_error() {
        let (sut, _) = makeSUT()
        let disco = DiscoSummary(id: UUID(), name: "Any", coverImage: Data())

        var receivedError: Error?
        sut.deleteDisco(disco) { result in
            if case let .failure(error) = result {
                receivedError = error
            }
        }

        XCTAssertEqual(
            receivedError?.localizedDescription,
            "A exclusão de discos ainda não foi migrada para a nova arquitetura"
        )
    }

    private func makeSUT() -> (sut: DiscoListRepositoryImpl, store: DiscoStoreSpy) {
        let store = DiscoStoreSpy()
        let sut = DiscoListRepositoryImpl(store: store)
        return (sut, store)
    }
}

private final class DiscoStoreSpy: DiscoStore {
    enum Message: Equatable {
        case getDiscos
        case createDisco(DiscoStoreRecord)
        case getProfiles
        case createProfile(DiscoProfileStoreRecord)
        case updateProfile(DiscoProfileStoreRecord)
    }

    private(set) var receivedMessages: [Message] = []

    var getDiscosCompletion: ((Result<[DiscoStoreRecord], Error>) -> Void)?
    var createDiscoCompletion: ((Result<DiscoStoreRecord, Error>) -> Void)?
    var getProfilesCompletion: ((Result<[DiscoProfileStoreRecord], Error>) -> Void)?
    var createProfileCompletion: ((Result<DiscoProfileStoreRecord, Error>) -> Void)?
    var updateProfileCompletion: ((Result<DiscoProfileStoreRecord, Error>) -> Void)?

    func getDiscos(completion: @escaping (Result<[DiscoStoreRecord], Error>) -> Void) {
        receivedMessages.append(.getDiscos)
        getDiscosCompletion = completion
    }

    func createDisco(
        _ disco: DiscoStoreRecord,
        completion: @escaping (Result<DiscoStoreRecord, Error>) -> Void
    ) {
        receivedMessages.append(.createDisco(disco))
        createDiscoCompletion = completion
    }

    func getProfiles(completion: @escaping (Result<[DiscoProfileStoreRecord], Error>) -> Void) {
        receivedMessages.append(.getProfiles)
        getProfilesCompletion = completion
    }

    func createProfile(
        _ profile: DiscoProfileStoreRecord,
        completion: @escaping (Result<DiscoProfileStoreRecord, Error>) -> Void
    ) {
        receivedMessages.append(.createProfile(profile))
        createProfileCompletion = completion
    }

    func updateProfile(
        _ profile: DiscoProfileStoreRecord,
        completion: @escaping (Result<DiscoProfileStoreRecord, Error>) -> Void
    ) {
        receivedMessages.append(.updateProfile(profile))
        updateProfileCompletion = completion
    }
}
