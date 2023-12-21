//
//  DataStorage.swift
//  Data
//
//  Created by Thiago Henrique on 16/12/23.
//

import Foundation

public protocol DiscoDataStorage {
    func getDiscos(
        completion: @escaping (Result<[DiscoDataEntity], Error>) -> Void
    )
    func createDisco(
        _ disco: DiscoDataEntity,
        completion: @escaping (Result<DiscoDataEntity, Error>) -> Void
    )
    
    func getProfiles(
        completion: @escaping (Result<[DiscoProfileDataEntity], Error>) -> Void
    )
    
    func createProfile(
        _ profile: DiscoProfileDataEntity,
        completion: @escaping (Result<DiscoProfileDataEntity, Error>) -> Void
    )

    func updateProfile(
        _ profile: DiscoProfileDataEntity,
        completion: @escaping (Result<DiscoProfileDataEntity, Error>) -> Void
    )
}
