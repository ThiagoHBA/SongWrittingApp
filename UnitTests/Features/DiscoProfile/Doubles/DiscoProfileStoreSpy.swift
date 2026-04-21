//
//  DiscoProfileStoreSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 20/04/26.
//


import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class DiscoProfileStoreSpy: DiscoStore {
    var getDiscosCompletion: ((Result<[DiscoStoreRecord], Error>) -> Void)?
    var createDiscoCompletion: ((Result<DiscoStoreRecord, Error>) -> Void)?
    var getProfilesCompletion: ((Result<[DiscoProfileStoreRecord], Error>) -> Void)?
    var createProfileCompletion: ((Result<DiscoProfileStoreRecord, Error>) -> Void)?
    var updateProfileCompletion: ((Result<DiscoProfileStoreRecord, Error>) -> Void)?

    @SWSpyMethodTracker
    func getDiscos(completion: @escaping (Result<[DiscoStoreRecord], Error>) -> Void) {
        receivedMessages.append(.getDiscos)
        getDiscosCompletion = completion
    }

    @SWSpyMethodTracker
    func createDisco(
        _ disco: DiscoStoreRecord,
        completion: @escaping (Result<DiscoStoreRecord, Error>) -> Void
    ) {
        receivedMessages.append(.createDisco(disco))
        createDiscoCompletion = completion
    }

    @SWSpyMethodTracker
    func getProfiles(completion: @escaping (Result<[DiscoProfileStoreRecord], Error>) -> Void) {
        receivedMessages.append(.getProfiles)
        getProfilesCompletion = completion
    }

    @SWSpyMethodTracker
    func createProfile(
        _ profile: DiscoProfileStoreRecord,
        completion: @escaping (Result<DiscoProfileStoreRecord, Error>) -> Void
    ) {
        receivedMessages.append(.createProfile(profile))
        createProfileCompletion = completion
    }

    @SWSpyMethodTracker
    func updateProfile(
        _ profile: DiscoProfileStoreRecord,
        completion: @escaping (Result<DiscoProfileStoreRecord, Error>) -> Void
    ) {
        receivedMessages.append(.updateProfile(profile))
        updateProfileCompletion = completion
    }

    func updateDisco(
        _ disco: DiscoStoreRecord,
        completion: @escaping (Result<DiscoStoreRecord, Error>) -> Void
    ) {}

    func deleteDisco(
        _ disco: DiscoStoreRecord,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {}
}
