//
//  CoreDataDiscoStoreTests.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import CoreData
import Foundation
import XCTest
@testable import Main

final class CoreDataDiscoStoreTests: XCTestCase {
    func test_createDisco_persists_disco() {
        let (sut, container) = makeSUT()
        let disco = makeDisco()

        let _ = waitForDiscoResult { completion in
            sut.createDisco(disco, completion: completion)
        }

        let persistedDiscos = fetchDiscoEntities(in: container.viewContext)

        XCTAssertEqual(persistedDiscos.first?.id, disco.id)
    }

    func test_createDisco_completes_with_created_disco() {
        let (sut, _) = makeSUT()
        let disco = makeDisco()

        let result = waitForDiscoResult { completion in
            sut.createDisco(disco, completion: completion)
        }

        XCTAssertEqual(try? result.get(), disco)
    }

    func test_getDiscos_returns_persisted_discos() {
        let (sut, container) = makeSUT()
        let expectedDisco = makeDisco()
        insertDiscoEntity(expectedDisco, in: container.viewContext)

        let result = waitForDiscosResult { completion in
            sut.getDiscos(completion: completion)
        }

        XCTAssertEqual(try? result.get(), [expectedDisco])
    }

    func test_createProfile_fails_when_related_disco_does_not_exist() {
        let (sut, _) = makeSUT()
        let profile = makeProfile()

        let result = waitForProfileResult { completion in
            sut.createProfile(profile, completion: completion)
        }

        XCTAssertEqual(result.failure as? StorageError, .cantLoadDisco)
    }

    func test_createProfile_persists_profile_with_references_and_sections() {
        let (sut, container) = makeSUT()
        let disco = makeDisco()
        insertDiscoEntity(disco, in: container.viewContext)
        let profile = makeProfile(disco: disco)

        let _ = waitForProfileResult { completion in
            sut.createProfile(profile, completion: completion)
        }

        let persistedProfiles = fetchDiscoProfileEntities(in: container.viewContext)

        XCTAssertEqual(persistedProfiles.count, 1)
        XCTAssertEqual(
            persistedProfiles.first?.references?.allObjects.count,
            profile.references.count
        )
        XCTAssertEqual(
            persistedProfiles.first?.sections?.allObjects.count,
            profile.section.count
        )
    }

    func test_createProfile_completes_with_created_profile() {
        let (sut, container) = makeSUT()
        let disco = makeDisco()
        insertDiscoEntity(disco, in: container.viewContext)
        let profile = makeProfile(disco: disco)

        let result = waitForProfileResult { completion in
            sut.createProfile(profile, completion: completion)
        }

        XCTAssertEqual(try? result.get(), profile)
    }

    func test_getProfiles_returns_persisted_profiles() {
        let (sut, container) = makeSUT()
        let profile = makeProfile()
        insertDiscoProfileEntity(profile, in: container.viewContext)

        let result = waitForProfilesResult { completion in
            sut.getProfiles(completion: completion)
        }

        XCTAssertEqual(try? result.get(), [profile])
    }

    func test_getProfiles_returns_sections_in_same_order_they_were_saved() {
        let (sut, container) = makeSUT()
        let expectedSections = [
            makeSection(identifier: "Verse", records: []),
            makeSection(
                identifier: "Chorus",
                records: [makeRecord(tag: .bass)]
            )
        ]
        let profile = makeProfile(section: expectedSections)
        insertDiscoProfileEntity(profile, in: container.viewContext)

        let result = waitForProfilesResult { completion in
            sut.getProfiles(completion: completion)
        }

        XCTAssertEqual(try? result.get().first?.section, expectedSections)
    }

    func test_getProfiles_preserves_record_tags() {
        let (sut, container) = makeSUT()
        let expectedTags: [InstrumentTagStoreRecord] = [
            .guitar,
            .vocal,
            .drums,
            .bass,
            .custom("Custom")
        ]
        let profile = makeProfile(
            section: expectedTags.enumerated().map { index, tag in
                makeSection(
                    identifier: "Section \(index)",
                    records: [makeRecord(tag: tag)]
                )
            }
        )
        insertDiscoProfileEntity(profile, in: container.viewContext)

        let result = waitForProfilesResult { completion in
            sut.getProfiles(completion: completion)
        }

        XCTAssertEqual(
            try? result.get().first?.section.compactMap { $0.records.first?.tag },
            expectedTags
        )
    }

    func test_updateProfile_fails_when_profile_does_not_exist() {
        let (sut, container) = makeSUT()
        let disco = makeDisco()
        insertDiscoEntity(disco, in: container.viewContext)
        let profile = makeProfile(disco: disco)

        let result = waitForProfileResult { completion in
            sut.updateProfile(profile, completion: completion)
        }

        XCTAssertEqual(result.failure as? StorageError, .cantLoadProfile)
    }

    func test_updateProfile_updates_existing_profile_references_and_sections() {
        let (sut, container) = makeSUT()
        let disco = makeDisco()
        insertDiscoEntity(disco, in: container.viewContext)
        insertDiscoProfileEntity(
            makeProfile(disco: disco, references: [], section: []),
            in: container.viewContext
        )
        let expectedProfile = makeProfile(disco: disco)

        let _ = waitForProfileResult { completion in
            sut.updateProfile(expectedProfile, completion: completion)
        }

        let persistedProfiles = fetchDiscoProfileEntities(in: container.viewContext)

        XCTAssertEqual(persistedProfiles.count, 1)
        XCTAssertEqual(
            persistedProfiles.first.flatMap(makeProfile(from:)),
            expectedProfile
        )
    }

    func test_updateProfile_completes_with_updated_profile() {
        let (sut, container) = makeSUT()
        let disco = makeDisco()
        insertDiscoEntity(disco, in: container.viewContext)
        insertDiscoProfileEntity(
            makeProfile(disco: disco, references: [], section: []),
            in: container.viewContext
        )
        let expectedProfile = makeProfile(disco: disco)

        let result = waitForProfileResult { completion in
            sut.updateProfile(expectedProfile, completion: completion)
        }

        XCTAssertEqual(try? result.get(), expectedProfile)
    }

    private func waitForDiscoResult(
        action: (@escaping (Result<DiscoStoreRecord, Error>) -> Void) -> Void
    ) -> Result<DiscoStoreRecord, Error> {
        waitForResult(timeout: 5.0, action: action)
    }

    private func waitForDiscosResult(
        action: (@escaping (Result<[DiscoStoreRecord], Error>) -> Void) -> Void
    ) -> Result<[DiscoStoreRecord], Error> {
        waitForResult(action: action)
    }

    private func waitForProfileResult(
        action: (@escaping (Result<DiscoProfileStoreRecord, Error>) -> Void) -> Void
    ) -> Result<DiscoProfileStoreRecord, Error> {
        waitForResult(action: action)
    }

    private func waitForProfilesResult(
        action: (@escaping (Result<[DiscoProfileStoreRecord], Error>) -> Void) -> Void
    ) -> Result<[DiscoProfileStoreRecord], Error> {
        waitForResult(action: action)
    }
    
    

    private func waitForResult<Value>(
        timeout: TimeInterval = 1.0,
        action: (@escaping (Result<Value, Error>) -> Void) -> Void
    ) -> Result<Value, Error> {
        let expectation = expectation(description: "Wait for result")
        var receivedResult: Result<Value, Error>?

        action { result in
            receivedResult = result
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: timeout)
        return receivedResult!
    }

    private func insertDiscoEntity(
        _ disco: DiscoStoreRecord,
        in context: NSManagedObjectContext
    ) {
        context.performAndWait {
            let discoEntity = DiscoEntity(context: context)
            discoEntity.id = disco.id
            discoEntity.name = disco.name
            discoEntity.coverImage = disco.coverImage
            try? context.save()
        }
    }

    private func insertDiscoProfileEntity(
        _ profile: DiscoProfileStoreRecord,
        in context: NSManagedObjectContext
    ) {
        context.performAndWait {
            let discoEntity = DiscoEntity(context: context)
            discoEntity.id = profile.disco.id
            discoEntity.name = profile.disco.name
            discoEntity.coverImage = profile.disco.coverImage

            let profileEntity = DiscoProfileEntity(context: context)
            profileEntity.disco = discoEntity
            profileEntity.references = NSSet(
                array: profile.references.map { reference in
                    let entity = AlbumReferenceEntity(context: context)
                    entity.name = reference.name
                    entity.artist = reference.artist
                    entity.releaseDate = reference.releaseDate
                    entity.coverImage = reference.coverImage
                    return entity
                }
            )
            profileEntity.sections = NSSet(
                array: profile.section.enumerated().map { index, section in
                    let sectionEntity = SectionEntity(context: context)
                    sectionEntity.identifier = section.identifer
                    sectionEntity.index = Int16(index)
                    sectionEntity.records = NSSet(
                        array: section.records.map { record in
                            let recordEntity = RecordEntity(context: context)
                            recordEntity.tag = persistedTag(from: record.tag)
                            recordEntity.audio = record.audio
                            return recordEntity
                        }
                    )
                    return sectionEntity
                }
            )
            try? context.save()
        }
    }

    private func fetchDiscoEntities(in context: NSManagedObjectContext) -> [DiscoEntity] {
        context.performAndWait {
            let request: NSFetchRequest<DiscoEntity> = DiscoEntity.fetchRequest()
            return (try? context.fetch(request)) ?? []
        }
    }

    private func fetchDiscoProfileEntities(in context: NSManagedObjectContext) -> [DiscoProfileEntity] {
        context.performAndWait {
            let request: NSFetchRequest<DiscoProfileEntity> = DiscoProfileEntity.fetchRequest()
            return (try? context.fetch(request)) ?? []
        }
    }
}

extension CoreDataDiscoStoreTests {
    typealias SutAndDoubles = (
        sut: CoreDataDiscoStore,
        container: NSPersistentContainer
    )
    
    func makeSUT() -> SutAndDoubles {
        let bundle = Bundle(for: CoreDataDiscoStore.self)
        let modelURL = bundle.url(
            forResource: DiscoStoreConstants.modelName,
            withExtension: DiscoStoreConstants.modelExtension
        )!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(
            name: DiscoStoreConstants.modelName,
            managedObjectModel: model
        )
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        let sut = CoreDataDiscoStore(persistentContainer: container)
        return (sut, container)
    }
}

extension CoreDataDiscoStoreTests {
    func makeDisco(
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
        references: [AlbumReferenceStoreRecord] = [
            AlbumReferenceStoreRecord(
                name: "Album",
                artist: "Artist",
                releaseDate: "2024-01-01",
                coverImage: "cover"
            )
        ],
        section: [SectionStoreRecord] = [
            SectionStoreRecord(
                identifer: "Verse",
                records: [
                    RecordStoreRecord(
                        tag: .guitar,
                        audio: URL(string: "https://example.com/audio-1")!
                    )
                ]
            ),
            SectionStoreRecord(
                identifer: "Chorus",
                records: [
                    RecordStoreRecord(
                        tag: .custom("Custom"),
                        audio: URL(string: "https://example.com/audio-2")!
                    )
                ]
            )
        ]
    ) -> DiscoProfileStoreRecord {
        DiscoProfileStoreRecord(disco: disco, references: references, section: section)
    }
    
    func makeSection(
        identifier: String,
        records: [RecordStoreRecord]
    ) -> SectionStoreRecord {
        SectionStoreRecord(identifer: identifier, records: records)
    }

    func makeRecord(
        tag: InstrumentTagStoreRecord,
        audio: URL = URL(string: "https://example.com/audio")!
    ) -> RecordStoreRecord {
        RecordStoreRecord(tag: tag, audio: audio)
    }
    
    func makeProfile(from entity: DiscoProfileEntity) -> DiscoProfileStoreRecord {
        let disco = DiscoStoreRecord(
            id: entity.disco?.id ?? UUID(),
            name: entity.disco?.name ?? "",
            coverImage: entity.disco?.coverImage ?? Data()
        )
        let references = (
            entity.references?.allObjects as? [AlbumReferenceEntity] ?? []
        ).map {
            AlbumReferenceStoreRecord(
                name: $0.name ?? "",
                artist: $0.artist ?? "",
                releaseDate: $0.releaseDate ?? "",
                coverImage: $0.coverImage ?? ""
            )
        }
        let sections = (
            entity.sections?.allObjects as? [SectionEntity] ?? []
        )
            .sorted { $0.index < $1.index }
            .map { sectionEntity in
                SectionStoreRecord(
                    identifer: sectionEntity.identifier ?? "",
                    records: (sectionEntity.records?.allObjects as? [RecordEntity] ?? [])
                        .map {
                            RecordStoreRecord(
                                tag: restoredTag(from: $0.tag),
                                audio: $0.audio!
                            )
                        }
                )
            }

        return DiscoProfileStoreRecord(
            disco: disco,
            references: references,
            section: sections
        )
    }
    
    func persistedTag(from tag: InstrumentTagStoreRecord) -> String {
        switch tag {
        case .guitar:
            return "Guitarra"
        case .vocal:
            return "Voz"
        case .drums:
            return "Bateria"
        case .bass:
            return "Baixo"
        case .custom(let value):
            return value
        }
    }

    private func restoredTag(from value: String?) -> InstrumentTagStoreRecord {
        switch value {
        case "Guitarra":
            return .guitar
        case "Voz":
            return .vocal
        case "Bateria":
            return .drums
        case "Baixo":
            return .bass
        case .some(let custom):
            return .custom(custom)
        case .none:
            return .custom("")
        }
    }
}

private extension Result {
    var failure: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}
