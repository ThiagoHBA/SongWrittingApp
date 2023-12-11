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
    
    public func loadProfile(
        for disco: Disco,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        guard let profileIndex = memoryDatabase.profiles.firstIndex(
            where: {
                $0.disco.id == disco.id
            }
        ) else {
            let newProfile = DiscoProfileDataEntity(
                disco: DiscoDataEntity(from: disco),
                references: .init(albums: .init(items: [])),
                section: []
            )
            memoryDatabase.profiles.append(newProfile)
            completion(.success(newProfile.toDomain()))
            return 
        }
        
        completion(.success(memoryDatabase.profiles[profileIndex].toDomain()))
    }
}
