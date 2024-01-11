//
//  InMemoryStorage.swift
//  Infra
//
//  Created by Thiago Henrique on 16/12/23.
//

import Foundation
import Data

public class InMemoryDatabase {
    public static let instance = InMemoryDatabase()

    var discos: [DiscoDataEntity] = []
    var profiles: [DiscoProfileDataEntity] = []

    public init () {}
}

public final class InMemoryDiscoStorage: DiscoDataStorage {
    let database: InMemoryDatabase
    
    public init(database: InMemoryDatabase = InMemoryDatabase.instance) {
        self.database = database
    }
    
    public func createDisco(
        _ disco: DiscoDataEntity,
        completion: @escaping (Result<DiscoDataEntity, Error>) -> Void
    ) {
        database.discos.append(disco)
        completion(.success(disco))
    }
    
    public func createProfile(
        _ profile: DiscoProfileDataEntity,
        completion: @escaping (Result<DiscoProfileDataEntity, Error>) -> Void
    ) {
        database.profiles.append(profile)
        completion(.success(profile))
    }
    
    public func getDiscos(
        completion: @escaping (Result<[DiscoDataEntity], Error>) -> Void
    ) {
        completion(.success(database.discos))
    }
    
    public func getProfiles(
        completion: @escaping (Result<[DiscoProfileDataEntity], Error>) -> Void
    ) {
        completion(.success(database.profiles))
    }
    
    public func updateProfile(
        _ profile: DiscoProfileDataEntity,
        completion: @escaping (Result<DiscoProfileDataEntity, Error>) -> Void
    ) {
        guard let profileIndex = database.profiles.firstIndex(where: {
            $0.disco == profile.disco
        } ) else {
            completion(.failure(StorageError.cantLoadProfile))
            return
        }
        
        database.profiles[profileIndex] = profile
        completion(.success(profile))
    }
    
    
}
