//
//  DiscoService.swift
//  DataTests
//
//  Created by Thiago Henrique on 10/12/23.
//

import XCTest
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
                case .success(_):
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
