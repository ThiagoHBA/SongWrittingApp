//
//  DiscoStore.swift
//  Main
//
//  Created by Thiago Henrique on 17/04/26.
//

import Foundation

public protocol DiscoStore {
    func getDiscos(
        completion: @escaping (Result<[DiscoStoreRecord], Error>) -> Void
    )

    func createDisco(
        _ disco: DiscoStoreRecord,
        completion: @escaping (Result<DiscoStoreRecord, Error>) -> Void
    )

    func getProfiles(
        completion: @escaping (Result<[DiscoProfileStoreRecord], Error>) -> Void
    )

    func createProfile(
        _ profile: DiscoProfileStoreRecord,
        completion: @escaping (Result<DiscoProfileStoreRecord, Error>) -> Void
    )

    func updateProfile(
        _ profile: DiscoProfileStoreRecord,
        completion: @escaping (Result<DiscoProfileStoreRecord, Error>) -> Void
    )
}
