//
//  DiscoServiceImpl.swift
//  Data
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation
import Domain

public class InMemoryDatabase {
    public static let instance = InMemoryDatabase()
    
    var discos: [DiscoDataEntity] = []
    var profiles: [DiscoProfileDataEntity] = []
    
    public init () {}
}

public final class DiscoServiceFromMemory: DiscoService {
    private var memoryDatabase: InMemoryDatabase
    
    public init(memoryDatabase: InMemoryDatabase = InMemoryDatabase.instance) {
        self.memoryDatabase = memoryDatabase
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
        guard let profileIndex = findProfileIndex(to: disco) else {
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
    
    public func updateDiscoReferences(
        _ disco: Disco,
        references: [AlbumReference],
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        guard let profileIndex = findProfileIndex(to: disco) else {
            completion(.failure(DataError.cantFindDisco))
            return
        }
        
        memoryDatabase.profiles[profileIndex].references = AlbumReferenceDataEntity(
            from: references
        )
        
        completion(.success(memoryDatabase.profiles[profileIndex].toDomain()))
    }
    
    public func addNewSection(
        _ disco: Disco,
        _ section: Section,
        completion: @escaping (Result<DiscoProfile, Error>
        ) -> Void) {
        guard let profileIndex = findProfileIndex(to: disco) else {
            completion(.failure(DataError.cantFindDisco))
            return
        }
        
        memoryDatabase.profiles[profileIndex].section.append(
            SectionDataEntity(from: section)
        )
        
        completion(.success(memoryDatabase.profiles[profileIndex].toDomain()))
    }
    
    private func findProfileIndex(to disco: Disco) -> Int? {
         return memoryDatabase.profiles.firstIndex(
            where: {
                $0.disco.id == disco.id
            }
        )
    }
}
