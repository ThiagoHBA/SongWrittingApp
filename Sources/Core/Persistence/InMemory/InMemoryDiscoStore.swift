//
//  InMemoryStorage.swift
//  Infra
//
//  Created by Thiago Henrique on 16/12/23.
//

import Foundation

public class InMemoryDatabase {
    public static let instance = InMemoryDatabase()

    var discos: [DiscoStoreRecord] = []
    var profiles: [DiscoProfileStoreRecord] = []

    public init () {}
}

public final class InMemoryDiscoStore: DiscoStore {
    let database: InMemoryDatabase
    
    public init(database: InMemoryDatabase = InMemoryDatabase.instance) {
        self.database = database
    }
    
    public func createDisco(
        _ disco: DiscoStoreRecord,
        completion: @escaping (Result<DiscoStoreRecord, Error>) -> Void
    ) {
        database.discos.append(disco)
        completion(.success(disco))
    }
    
    public func createProfile(
        _ profile: DiscoProfileStoreRecord,
        completion: @escaping (Result<DiscoProfileStoreRecord, Error>) -> Void
    ) {
        database.profiles.append(profile)
        completion(.success(profile))
    }
    
    public func getDiscos(
        completion: @escaping (Result<[DiscoStoreRecord], Error>) -> Void
    ) {
        completion(.success(database.discos))
    }
    
    public func getProfiles(
        completion: @escaping (Result<[DiscoProfileStoreRecord], Error>) -> Void
    ) {
        completion(.success(database.profiles))
    }
    
    public func updateProfile(
        _ profile: DiscoProfileStoreRecord,
        completion: @escaping (Result<DiscoProfileStoreRecord, Error>) -> Void
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
