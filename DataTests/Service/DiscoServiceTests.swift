//
//  DiscoService.swift
//  DataTests
//
//  Created by Thiago Henrique on 09/01/24.
//

import XCTest
import Domain
@testable import Data

final class DiscoServiceTests: XCTestCase {
    func test_createDisco_should_fetch_all_discos_first() {
        let (sut, storageSpy) = makeSUT()
        let inputName = "Any"
        let inputImage = Data()
        
        sut.createDisco(name: inputName, image: inputImage) { _ in }
        storageSpy.getDiscosCompletion?(.success([]))
        
        XCTAssertEqual(storageSpy.receivedMessages.first, .getDiscos)
    }
    
    func test_createDisco_should_fail_if_fetch_failed() {
        let (sut, storageSpy) = makeSUT()
        let inputName = "Any"
        let inputImage = Data()
        let inputError = NSError(domain: "any", code: 0)
        
        sut.createDisco(name: inputName, image: inputImage) { result in
            if case let .failure(error) = result {
                XCTAssertEqual(error.localizedDescription, inputError.localizedDescription)
            } else {
                XCTFail("Shouldnt succeed")
            }
        }
        
        storageSpy.getDiscosCompletion?(.failure(inputError))
    }
    
    func test_createDisco_shouldnt_create_disco_if_another_disco_with_same_name_exists() {
        let (sut, storageSpy) = makeSUT()
        let inputName = "Any"
        let inputImage = Data()
        let inputDisco = DiscoDataEntity(id: UUID(), name: inputName, coverImage: inputImage)
        let expectedError = DataError.nameAlreadyExist
        
        sut.createDisco(name: inputName, image: inputImage) { result in
            switch result {
            case .success(_):
                XCTFail("Shouldnt succeed")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
            }
        }
        storageSpy.getDiscosCompletion?(.success([inputDisco]))
    }
    
    func test_createDisco_should_create_a_disco_correctly() {
        let (sut, storageSpy) = makeSUT()
        let inputName = "Any"
        let inputImage = Data()
        let inputDisco = DiscoDataEntity(id: UUID(), name: inputName, coverImage: inputImage)
        let expectedDisco = inputDisco.toDomain()
        
        sut.createDisco(name: inputName, image: inputImage) { result in
            switch result {
            case .success(let disco):
                XCTAssertEqual(disco, expectedDisco)
            case .failure(let error):
                self.unexpectedErrorThrowed(error)
            }
        }
        
        storageSpy.getDiscosCompletion?(.success([]))
        storageSpy.createDiscoCompletion?(.success(inputDisco))
    }
    
    func test_createDisco_should_throw_failure_if_cant_create_disco() {
        let (sut, storageSpy) = makeSUT()
        let inputName = "Any"
        let inputImage = Data()
        let inputError = NSError(domain: "any", code: 0)
        
        sut.createDisco(name: inputName, image: inputImage) { result in
            switch result {
            case .success(_):
                XCTFail("shouldnt succeed")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, inputError.localizedDescription)
            }
        }
        
        storageSpy.getDiscosCompletion?(.success([]))
        storageSpy.createDiscoCompletion?(.failure(inputError))
    }
    
    func test_loadProfile_should_fetch_all_profiles_first() {
        let (sut, storageSpy) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        sut.loadProfile(for: inputDisco) { _ in }
        
        storageSpy.getProfilesCompletion?(.success([]))
        
        XCTAssertEqual(storageSpy.receivedMessages.first, .getProfiles)
    }
    
    func test_loadProfile_if_cant_find_profile_for_disco_should_create_a_new_one() {
        let (sut, storageSpy) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputProfile = DiscoProfileDataEntity.createEmptyProfile(for: inputDisco)
        let expectedProfile = inputProfile.toDomain()
        
        sut.loadProfile(for: inputDisco) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedProfile)
            case .failure(let error):
                self.unexpectedErrorThrowed(error)
            }
        }
        
        storageSpy.getProfilesCompletion?(.success([]))
        storageSpy.createProfileCompletion?(.success(inputProfile))
    }
    
    func test_loadProfile_if_cant_create_profile_should_throw_error() {
        let (sut, storageSpy) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputError = NSError(domain: "any", code: 0)
          
        sut.loadProfile(for: inputDisco) { result in
            switch result {
            case .success(_):
                XCTFail("shouldnt succeed")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, inputError.localizedDescription)
            }
        }
        
        storageSpy.getProfilesCompletion?(.success([]))
        storageSpy.createProfileCompletion?(.failure(inputError))
    }
    
    func test_loadProfile_if_find_a_profile_for_disco_should_return() {
        let (sut, storageSpy) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputProfile = DiscoProfileDataEntity.createEmptyProfile(for: inputDisco)
        let expectedProfile = inputProfile.toDomain()
        
        sut.loadProfile(for: inputDisco) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, expectedProfile)
            case .failure(let error):
                self.unexpectedErrorThrowed(error)
            }
        }
        
        storageSpy.getProfilesCompletion?(.success([inputProfile]))
    }
    
    func test_loadProfile_should_fail_if_fetch_all_profiles_fail() {
        let (sut, storageSpy) = makeSUT()
        let inputDisco = Disco(id: UUID(), name: "any", coverImage: Data())
        let inputError = NSError(domain: "any", code: 0)
        
        sut.loadProfile(for: inputDisco) { result in
            switch result {
            case .success(_):
                XCTFail("Shouldnt Succeed")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, inputError.localizedDescription)
            }
        }
        
        storageSpy.getProfilesCompletion?(.failure(inputError))
    }
}

extension DiscoServiceTests {
    func unexpectedErrorThrowed(_ error: Error) {
        XCTFail("Shouldnt fail but: \(error.localizedDescription)")
    }
}

extension DiscoServiceTests: Testing {
    typealias SutAndDoubles = (
        sut: DiscoServiceImpl,
        storageSpy: DiscoStorageSpy
    )
    
    func makeSUT() -> SutAndDoubles {
        let storageSpy = DiscoStorageSpy()
        let sut = DiscoServiceImpl(storage: storageSpy)
        return (sut, storageSpy)
    }
}
