import Foundation
import XCTest
import SongWrittingMacros
@testable import Main

final class DiscoListRepositoryImplTests: XCTestCase {
    func test_execute_fetches_from_store() {
        let (sut, store) = makeSUT()

        sut.load(.init()) { _ in }
        store.getDiscosCompletion?(.success([]))

        XCTAssertEqual(store.receivedMessages, [.getDiscos])
    }

    func test_createDisco_fails_when_name_already_exists() throws {
        let (sut, store) = makeSUT()
        let expectedError = "Um disco com o mesmo nome já foi criado"
        let existingDisco = DiscoStoreRecord(id: UUID(), name: "Any", coverImage: Data())
        let disco = try XCTUnwrap(try? Disco(name: "Any", image: Data("image".utf8)))

        var receivedError: Error?
        sut.create(disco) { result in
            if case let .failure(error) = result {
                receivedError = error
            }
        }

        store.getDiscosCompletion?(.success([existingDisco]))

        XCTAssertEqual(store.receivedMessages, [.getDiscos])
        XCTAssertEqual(receivedError?.localizedDescription, expectedError)
    }

    func test_createDisco_creates_summary_when_name_is_unique() throws {
        let (sut, store) = makeSUT()
        let expectedImage = Data("cover".utf8)
        let disco = try XCTUnwrap(try? Disco(name: "New", image: expectedImage))

        var receivedDisco: DiscoSummary?
        sut.create(disco) { result in
            if case let .success(disco) = result {
                receivedDisco = disco
            }
        }

        store.getDiscosCompletion?(.success([]))
        
        guard let passedRecord = store.receivedMessages.compactMap({ message -> DiscoStoreRecord? in
            if case let .createDisco(record) = message { return record }
            return nil
        }).first else {
            XCTFail("createDisco should have been called")
            return
        }
        
        store.createDiscoCompletion?(.success(passedRecord))

        XCTAssertEqual(store.receivedMessages, [.getDiscos, .createDisco(passedRecord)])
        XCTAssertEqual(passedRecord.name, "New")
        XCTAssertEqual(passedRecord.coverImage, expectedImage)
        XCTAssertEqual(receivedDisco, DiscoSummary(id: passedRecord.id, name: "New", coverImage: expectedImage))
    }

    func test_deleteDisco_calls_store_deleteDisco() {
        let (sut, store) = makeSUT()
        let disco = DiscoSummary(id: UUID(), name: "Any", coverImage: Data())

        sut.delete(.init(disco: disco)) { _ in }

        XCTAssertEqual(
            store.receivedMessages,
            [.deleteDisco(DiscoStoreRecord(id: disco.id, name: disco.name, coverImage: disco.coverImage))]
        )
    }

    func test_deleteDisco_onSuccess_returns_deleted_disco() {
        let (sut, store) = makeSUT()
        let disco = DiscoSummary(id: UUID(), name: "Any", coverImage: Data())
        var receivedDisco: DiscoSummary?

        sut.delete(.init(disco: disco)) { result in
            if case let .success(deleted) = result { receivedDisco = deleted }
        }
        store.deleteDiscoCompletion?(.success(()))

        XCTAssertEqual(receivedDisco, disco)
    }

    private func makeSUT() -> (sut: DiscoListRepositoryImpl, store: DiscoStoreSpy) {
        let store = DiscoStoreSpy()
        let sut = DiscoListRepositoryImpl(store: store)
        return (sut, store)
    }
}
