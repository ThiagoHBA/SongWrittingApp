//
//  DiscoStorageSpy.swift
//  DataTests
//
//  Created by Thiago Henrique on 09/01/24.
//

import Foundation
import Data

final class DiscoStorageSpy {
    private(set) var receivedMessages: [Message] = [Message]()

    enum Message: Equatable, CustomStringConvertible {
        case getDiscos
        case createDisco(DiscoDataEntity)
        case getProfiles
        case createProfile(DiscoProfileDataEntity)
        case updateProfile(DiscoProfileDataEntity)
        
        var description: String {
            switch self {
            case .getDiscos:
                return "getDiscos called"
            case .createDisco(let data):
                return "createDisco called with data: \(data)"
            case .getProfiles:
                return "getProfiles called"
            case .createProfile(let data):
                return "createProfile called with data: \(data)"
            case .updateProfile(let data):
                return "updateProfile called with data: \(data)"
            }
        }
    }
    
    //MARK: - Completions
    private(set) var getDiscosCompletion: ((Result<[DiscoDataEntity], Error>) -> Void)?
    private(set) var getProfilesCompletion: ((Result<[DiscoProfileDataEntity], Error>) -> Void)?
    private(set) var createDiscoCompletion: ((Result<DiscoDataEntity, Error>) -> Void)?
    private(set) var createProfileCompletion: ((Result<DiscoProfileDataEntity, Error>) -> Void)?
}

extension DiscoStorageSpy: DiscoDataStorage {
    func getDiscos(
        completion: @escaping (Result<[DiscoDataEntity], Error>) -> Void
    ) {
        getDiscosCompletion = completion
        receivedMessages.append(.getDiscos)
    }
    
    func createDisco(
        _ disco: DiscoDataEntity,
        completion: @escaping (Result<DiscoDataEntity, Error>) -> Void
    ) {
        createDiscoCompletion = completion
        receivedMessages.append(.createDisco(disco))
    }
    
    func getProfiles(
        completion: @escaping (Result<[DiscoProfileDataEntity], Error>) -> Void
    ) {
        getProfilesCompletion = completion
        receivedMessages.append(.getProfiles)
    }
    
    func createProfile(
        _ profile: DiscoProfileDataEntity,
        completion: @escaping (Result<DiscoProfileDataEntity, Error>) -> Void
    ) {
        createProfileCompletion = completion
        receivedMessages.append(.createProfile(profile))
    }
    
    func updateProfile(
        _ profile: DiscoProfileDataEntity,
        completion: @escaping (Result<DiscoProfileDataEntity, Error>) -> Void
    ) {
        receivedMessages.append(.updateProfile(profile))
    }
}
