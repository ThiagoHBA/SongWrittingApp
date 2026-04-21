//
//  InMemoryDiscoStoreTests.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import XCTest
@testable import Main

final class InMemoryDiscoStoreTests: XCTestCase {
    func test_createDisco_stores_disco_in_database() {
        let (sut, database) = makeSUT()
        let disco = createDisco()

        sut.createDisco(disco) { _ in }

        XCTAssertEqual(database.discos, [disco])
    }

    func test_createDisco_completes_with_created_disco() {
        let (sut, _) = makeSUT()
        let expectedDisco = createDisco()
        var receivedDisco: DiscoStoreRecord?

        sut.createDisco(expectedDisco) { result in
            if case let .success(disco) = result {
                receivedDisco = disco
            }
        }

        XCTAssertEqual(receivedDisco, expectedDisco)
    }

    func test_getDiscos_returns_database_discos() {
        let (sut, database) = makeSUT()
        let expectedDiscos = [createDisco()]
        database.discos = expectedDiscos
        var receivedDiscos: [DiscoStoreRecord]?

        sut.getDiscos { result in
            if case let .success(discos) = result {
                receivedDiscos = discos
            }
        }

        XCTAssertEqual(receivedDiscos, expectedDiscos)
    }

    func test_createProfile_stores_profile_in_database() {
        let (sut, database) = makeSUT()
        let profile = makeProfile()

        sut.createProfile(profile) { _ in }

        XCTAssertEqual(database.profiles, [profile])
    }

    func test_createProfile_completes_with_created_profile() {
        let (sut, _) = makeSUT()
        let expectedProfile = makeProfile()
        var receivedProfile: DiscoProfileStoreRecord?

        sut.createProfile(expectedProfile) { result in
            if case let .success(profile) = result {
                receivedProfile = profile
            }
        }

        XCTAssertEqual(receivedProfile, expectedProfile)
    }

    func test_getProfiles_returns_database_profiles() {
        let (sut, database) = makeSUT()
        let expectedProfiles = [makeProfile()]
        database.profiles = expectedProfiles
        var receivedProfiles: [DiscoProfileStoreRecord]?

        sut.getProfiles { result in
            if case let .success(profiles) = result {
                receivedProfiles = profiles
            }
        }

        XCTAssertEqual(receivedProfiles, expectedProfiles)
    }

    func test_updateProfile_updates_matching_profile_in_database() {
        let (sut, database) = makeSUT()
        let disco = createDisco()
        let existingProfile = makeProfile(disco: disco)
        let updatedProfile = makeProfile(
            disco: disco,
            references: [
                AlbumReferenceStoreRecord(
                    name: "Album",
                    artist: "Artist",
                    releaseDate: "2024-01-01",
                    coverImage: "cover"
                )
            ]
        )
        database.profiles = [existingProfile]

        sut.updateProfile(updatedProfile) { _ in }

        XCTAssertEqual(database.profiles, [updatedProfile])
    }

    func test_updateProfile_completes_with_updated_profile() {
        let (sut, database) = makeSUT()
        let disco = createDisco()
        let existingProfile = makeProfile(disco: disco)
        let expectedProfile = makeProfile(
            disco: disco,
            section: [SectionStoreRecord(identifer: "Verse", records: [])]
        )
        database.profiles = [existingProfile]
        var receivedProfile: DiscoProfileStoreRecord?

        sut.updateProfile(expectedProfile) { result in
            if case let .success(profile) = result {
                receivedProfile = profile
            }
        }

        XCTAssertEqual(receivedProfile, expectedProfile)
    }

    func test_updateProfile_fails_when_profile_does_not_exist() {
        let (sut, _) = makeSUT()
        let profile = makeProfile()
        var receivedError: StorageError?

        sut.updateProfile(profile) { result in
            if case let .failure(error) = result {
                receivedError = error as? StorageError
            }
        }

        XCTAssertEqual(receivedError, .cantLoadProfile)
    }
}

extension InMemoryDiscoStoreTests {
    typealias SutAndDoubles = (
        sut: InMemoryDiscoStore,
        database: InMemoryDatabase
    )
    
    private func makeSUT() -> SutAndDoubles {
        let database = InMemoryDatabase()
        let sut = InMemoryDiscoStore(database: database)
        return (sut, database)
    }
}

extension InMemoryDiscoStoreTests {
    func createDisco(
        id: UUID = UUID(),
        name: String = "Any Disco",
        coverImage: Data = Data("cover".utf8)
    ) -> DiscoStoreRecord {
        DiscoStoreRecord(id: id, name: name, coverImage: coverImage)
    }

    func makeProfile(
        disco: DiscoStoreRecord = DiscoStoreRecord(
            id: UUID(),
            name: "Any Disco",
            coverImage: Data("cover".utf8)
        ),
        references: [AlbumReferenceStoreRecord] = [],
        section: [SectionStoreRecord] = []
    ) -> DiscoProfileStoreRecord {
        DiscoProfileStoreRecord(
            disco: disco,
            references: references,
            section: section
        )
    }
}
