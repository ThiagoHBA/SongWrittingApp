import Foundation
import XCTest
@testable import Main

final class DiscoProfileRepositoryImplTests: XCTestCase {
    func test_loadProfile_fetches_profiles_first() {
        let (sut, store) = makeSUT()
        let disco = makeDisco()

        sut.load(disco) { _ in }
        store.getProfilesCompletion?(.success([]))
        store.createProfileCompletion?(.success(makeEmptyProfileRecord(for: disco)))

        XCTAssertEqual(store.receivedMessages.first, .getProfiles)
    }

    func test_loadProfile_creates_profile_when_missing() {
        let (sut, store) = makeSUT()
        let disco = makeDisco()
        let createdProfile = makeEmptyProfileRecord(for: disco)
        var receivedProfile: DiscoProfile?

        sut.load(disco) { result in
            if case let .success(profile) = result {
                receivedProfile = profile
            }
        }

        store.getProfilesCompletion?(.success([]))
        store.createProfileCompletion?(.success(createdProfile))

        XCTAssertEqual(
            store.receivedMessages,
            [.getProfiles, .createProfile(createdProfile)]
        )
        XCTAssertEqual(receivedProfile, DiscoProfileStoreMapper.profile(from: createdProfile))
    }

    func test_loadProfile_returns_existing_profile_when_found() {
        let (sut, store) = makeSUT()
        let disco = makeDisco()
        let existingProfile = makeProfileRecord(for: disco)
        var receivedProfile: DiscoProfile?

        sut.load(disco) { result in
            if case let .success(profile) = result {
                receivedProfile = profile
            }
        }

        store.getProfilesCompletion?(.success([existingProfile]))

        XCTAssertEqual(store.receivedMessages, [.getProfiles])
        XCTAssertEqual(receivedProfile, DiscoProfileStoreMapper.profile(from: existingProfile))
    }

    func test_addSection_updates_profile_with_new_section() throws {
        let (sut, store) = makeSUT()
        let disco = makeDisco()
        let section = try Section(identifer: "Verse", records: [])
        let existingProfile = makeEmptyProfileRecord(for: disco)
        let updatedProfile = DiscoProfileStoreRecord(
            disco: existingProfile.disco,
            references: [],
            section: [DiscoProfileStoreMapper.storeSection(from: section)]
        )
        var receivedProfile: DiscoProfile?

        sut.addSection(.init(disco: disco, section: section)) { result in
            if case let .success(profile) = result {
                receivedProfile = profile
            }
        }

        store.getProfilesCompletion?(.success([existingProfile]))
        store.updateProfileCompletion?(.success(updatedProfile))

        XCTAssertEqual(
            store.receivedMessages,
            [.getProfiles, .updateProfile(updatedProfile)]
        )
        XCTAssertEqual(receivedProfile?.section, [section])
    }

    func test_addRecord_fails_when_target_section_cannot_be_found() throws {
        let (sut, store) = makeSUT()
        let disco = makeDisco()
        let section = try Section(
            identifer: "Verse",
            records: [.init(tag: .bass, audio: URL(string: "https://example.com/audio")!)]
        )
        let existingProfile = makeEmptyProfileRecord(for: disco)
        var receivedError: Error?

        sut.addRecord(.init(disco: disco, section: section)) { result in
            if case let .failure(error) = result {
                receivedError = error
            }
        }

        store.getProfilesCompletion?(.success([existingProfile]))

        XCTAssertEqual(store.receivedMessages, [.getProfiles])
        XCTAssertEqual(
            receivedError?.localizedDescription,
            "Não foi possível encontrar a sessão para adição da gravação"
        )
    }

    private func makeSUT() -> (sut: DiscoProfileRepositoryImpl, store: DiscoProfileStoreSpy) {
        let store = DiscoProfileStoreSpy()
        let sut = DiscoProfileRepositoryImpl(store: store)
        return (sut, store)
    }

    private func makeDisco() -> DiscoSummary {
        DiscoSummary(id: UUID(), name: "Any", coverImage: Data("cover".utf8))
    }

    private func makeEmptyProfileRecord(for disco: DiscoSummary) -> DiscoProfileStoreRecord {
        DiscoProfileStoreRecord(
            disco: DiscoStoreRecord(id: disco.id, name: disco.name, coverImage: disco.coverImage),
            references: [],
            section: []
        )
    }

    private func makeProfileRecord(for disco: DiscoSummary) -> DiscoProfileStoreRecord {
        let section = SectionStoreRecord(
            identifer: "Chorus",
            records: [
                RecordStoreRecord(
                    tag: .guitar,
                    audio: URL(string: "https://example.com/audio")!
                )
            ]
        )
        return DiscoProfileStoreRecord(
            disco: DiscoStoreRecord(id: disco.id, name: disco.name, coverImage: disco.coverImage),
            references: [
                AlbumReferenceStoreRecord(
                    name: "Album",
                    artist: "Artist",
                    releaseDate: "2024-01-01",
                    coverImage: "https://example.com/image"
                )
            ],
            section: [section]
        )
    }
}

private final class DiscoProfileStoreSpy: DiscoStore {
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
