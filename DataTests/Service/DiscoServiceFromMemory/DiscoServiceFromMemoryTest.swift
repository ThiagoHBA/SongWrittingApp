//
//  DiscoService.swift
//  DataTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import XCTest
import Domain
@testable import Data

final class DiscoServiceFromMemoryTest: XCTestCase {
    func test_init_when_created_without_parameters_should_create_empty_database() {
        let sut = DiscoServiceFromMemory()
        sut.loadDiscos { result in
            switch result {
            case .success(let discoList):
                XCTAssertEqual(discoList.count, 0)
            case .failure(let error):
                self.unexpectedErrorThrowed(error)
            }
        }
    }

    func test_createDisco_should_append_new_disco_on_database() {
        let (sut, (databaseSpy)) = makeSUT()
        sut.createDisco(
            name: "any name",
            image: Data(),
            completion: { result in
                switch result {
                case .success:
                    XCTAssertEqual(databaseSpy.discos.count, 1)
                case .failure(let error):
                    self.unexpectedErrorThrowed(error)
                }
            }
        )
    }

    func test_loadDiscos_when_create_new_disco_should_load_correctly() {
        let (sut, (databaseSpy)) = makeSUT()
        databaseSpy.discos = [DiscoDataEntity(id: UUID(), name: "any", coverImage: Data())]
        sut.loadDiscos { result in
            switch result {
            case .success(let discoList):
                XCTAssertEqual(discoList.count, 1)
            case .failure(let error):
                self.unexpectedErrorThrowed(error)
            }
        }
    }

    func test_loadProfile_when_disco_doesnt_have_profile_should_create_a_new() {
        let (sut, (_)) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        sut.loadProfile(for: inputDisco) { result in
            switch result {
            case .success(let profile):
            XCTAssertEqual(profile.disco, inputDisco)
            case .failure(let error):
                self.unexpectedErrorThrowed(error)
            }
        }
    }

    func test_loadProfile_when_disco_have_profile_should_return_correctly() {
        let (sut, (databaseSpy)) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputProfile: DiscoProfileDataEntity = .init(
            disco: DiscoDataEntity(from: inputDisco),
            references: AlbumReferenceDataEntity(albums: .init(items: [])),
            section: []
        )
        databaseSpy.profiles = [inputProfile]

        sut.loadProfile(for: inputDisco) { result in
            switch result {
            case .success(let profile):
                XCTAssertEqual(profile, inputProfile.toDomain())
            case .failure(let error):
                self.unexpectedErrorThrowed(error)
            }
        }
    }

    func test_updateDiscoReferences_when_cant_find_profile_should_throw_error() {
        let (sut, (_)) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        sut.updateDiscoReferences(inputDisco, references: []) { result in
            switch result {
            case .success(let data):
            XCTFail("Shouldnt succeed, but: \(data)")
            case .failure:
                break
            }
        }
    }

    func test_updateDiscoReferences_when_succeed_should_complete_with_correct_profile() {
        let (sut, (databaseSpy)) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputProfile: DiscoProfileDataEntity = .init(
            disco: DiscoDataEntity(from: inputDisco),
            references: AlbumReferenceDataEntity(albums: .init(items: [])),
            section: []
        )
        databaseSpy.profiles = [inputProfile]

        sut.updateDiscoReferences(inputDisco, references: []) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, inputProfile.toDomain())
            case .failure(let error):
                self.unexpectedErrorThrowed(error)
            }
        }
    }

    func test_addNewSection_when_cant_find_profile_should_throw_error() {
        let (sut, (_)) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputSection = Section(identifer: "any", records: [])
        sut.addNewSection(inputDisco, inputSection) { result in
            switch result {
            case .success(let data):
                XCTFail("Shouldnt succeed, but: \(data)")
            case .failure:
                break
            }
        }
    }

    func test_addNewSection_when_succeed_should_complete_with_correct_profile() {
        let (sut, (databaseSpy)) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputSection = Section(identifer: "any", records: [])
        let inputProfile: DiscoProfileDataEntity = .init(
            disco: DiscoDataEntity(from: inputDisco),
            references: AlbumReferenceDataEntity(albums: .init(items: [])),
            section: []
        )
        let expectedProfile: DiscoProfileDataEntity = .init(
            disco: inputProfile.disco,
            references: inputProfile.references,
            section: [SectionDataEntity(from: inputSection)]
        )

        databaseSpy.profiles = [inputProfile]
        sut.addNewSection(inputDisco, inputSection) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedProfile.toDomain())
            case .failure(let error):
                self.unexpectedErrorThrowed(error)
            }
        }
    }

    func test_addNewRecord_when_cant_find_profile_should_throw_error() {
        let (sut, (_)) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputSection = Section(identifer: "any", records: [])

        sut.addNewRecord(inputDisco, inputSection) { result in
            switch result {
            case .success(let data):
                XCTFail("Shouldnt succeed, but: \(data)")
            case .failure:
                break
            }
        }
    }

    func test_addNewRecord_when_cant_find_section_should_throw_error() {
        let (sut, (databaseSpy)) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputSection = Section(identifer: "any", records: [])
        let inputProfile: DiscoProfileDataEntity = .init(
            disco: DiscoDataEntity(from: inputDisco),
            references: AlbumReferenceDataEntity(albums: .init(items: [])),
            section: []
        )
        databaseSpy.profiles = [inputProfile]

        sut.addNewRecord(inputDisco, inputSection) { result in
            switch result {
            case .success(let data):
                XCTFail("Shouldnt succeed, but: \(data)")
            case .failure:
                break
            }
        }
    }

    func test_addNewRecord_when_find_section_should_append_record_correctly() {
        let (sut, (databaseSpy)) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputSection = Section(
            identifer: "any",
            records: [.init(tag: .guitar, audio: URL(string: "https://www.any.com")!)]
        )

        let inputProfile: DiscoProfileDataEntity = .init(
            disco: DiscoDataEntity(from: inputDisco),
            references: AlbumReferenceDataEntity(albums: .init(items: [])),
            section: [.init(from: inputSection)]
        )

        databaseSpy.profiles = [inputProfile]

        sut.addNewRecord(inputDisco, inputSection) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, inputProfile.toDomain())
            case .failure(let error):
                self.unexpectedErrorThrowed(error)
            }
        }
    }
}

extension DiscoServiceFromMemoryTest: Testing {
    typealias SutAndDoubles = (DiscoServiceFromMemory, (InMemoryDatabase))

    func makeSUT() -> SutAndDoubles {
        let databaseSpy = InMemoryDatabase()
        let sut = DiscoServiceFromMemory(memoryDatabase: databaseSpy)
        return (sut, (databaseSpy))
    }

    func unexpectedErrorThrowed(_ error: Error) {
        XCTFail("\(#function) should not throw an error, but, instead: \(error)")
    }
}
