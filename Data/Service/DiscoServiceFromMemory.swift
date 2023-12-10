//
//  DiscoServiceImpl.swift
//  Data
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation
import Domain

internal class InMemoryDatabase {
    var discos: [DiscoDataEntity] = []
    var profiles: [DiscoProfileDataEntity] = []
}

public final class DiscoServiceFromMemory: DiscoService {
    private var memoryDatabase: InMemoryDatabase
    
    internal init(memoryDatabase: InMemoryDatabase = InMemoryDatabase()) {
        self.memoryDatabase = memoryDatabase
    }
    
    public init() {
        self.memoryDatabase = InMemoryDatabase()
    }

    public func createDisco(
        name: String,
        image: Data,
        completion: @escaping (Result<Disco, Error>) -> Void
    ) {
        let newDisco = DiscoDataEntity(id: UUID(), name: name, coverImage: image)
        memoryDatabase.discos.append(newDisco)
        completion(.success(newDisco.toDomain()))
    }
    
    public func loadDiscos(completion: @escaping (Result<[Disco], Error>) -> Void) {
        completion(.success(memoryDatabase.discos.map { $0.toDomain() }))
    }
}
