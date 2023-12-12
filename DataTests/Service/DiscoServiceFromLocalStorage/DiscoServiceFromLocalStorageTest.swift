//
//  DiscoServiceFromLocalStorage.swift
//  DataTests
//
//  Created by Thiago Henrique on 12/12/23.
//

import XCTest
import Domain
@testable import Data

final class DiscoServiceFromLocalStorageTest: XCTestCase {
    func test_example() {
        let container = NSPersistentContainer(name: "SongWrittingApp")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }

        let sut = DiscoServiceFromStorage(persistentContainer: container)
        let inputDisco = Disco(
            id: UUID(),
            name: "any",
            coverImage: Data()
        )
        sut.createDisco(
            name: inputDisco.name,
            image: inputDisco.coverImage
        ) { result in
            switch result {
            case .success(let data):
                print("Data: \(data)")
            case .failure(let error):
                print("Error: \(error)")
            }

        }
    }
}
