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
//        let concQueue = DispatchQueue(label: "com.thiago.concQueue", attributes: .concurrent)
//        
//        concQueue.async {
//            var counter = 0
//            for _ in 0..<100000000 {
//                counter += 1
//            }
//            concQueue.sync {
//                print("Sync!!!")
//            }
            completion(.success(self.database.discos))
//        }
//        let semaphore = DispatchSemaphore(value: 0)
//        
//        executeTask01()
//        executeTask02()
//        
//        func executeTask01() {
//            print("Entrando Bloco01")
//            concQueue.async {
//                print("Waiting...")
//                semaphore.wait()
//                var counter = 0
//                for _ in 0..<100000000 {
//                    counter += 1
//                }
//                print("Saindo Bloco01")
//            }
//        }
//        
//        func executeTask02() {
//            concQueue.async {
//                print("Entrando Bloco02")
//                var counter = 0
//                for _ in 0..<1000000 {
//                    counter += 1
//                }
//                print("Saindo Bloco02")
//                semaphore.signal()
//            }
//        }
//        
        
//        let serialQueue = DispatchQueue(
//            label: "com.thiago.serialQueue"
//        )
//        
//        serialQueue.async(qos: .utility) {
//            print("Executando bloco 01")
//            var counter = 0
//            for _ in 0..<100000000 {
//                counter += 1
//            }
//
//            completion(.success(self.database.discos))
//        }
//        
//        serialQueue.async(qos: .utility) {
//            serialQueue.asyncAfter(deadline: .now() + 2) {
//                print("Executando bloco 02")
//                var counter = 0
//                for _ in 0..<100000000 {
//                    counter += 1
//                }
//                
//                completion(.success(self.database.discos))
//            }
//        }
        
//        DispatchQueue.global(qos: .utility).async {
//            print("Executando bloco 01")
//            var counter = 0
//            for _ in 0..<100000000 {
//                counter += 1
//            }
//
//            completion(.success(self.database.discos))
//        }
//        
//        DispatchQueue.global(qos: .utility).async {
//            print("Executando bloco 02")
//            var counter = 0
//            for _ in 0..<100000000 {
//                counter += 1
//            }
//            
//            completion(.success(self.database.discos))
//        }
//        let concurrentQueue = DispatchQueue(
//            label: "com.thiago.concurrentQueue"
//        )
//        executeTask01()
//        executeTask02()
//        
//        completion(.success(self.database.discos))
//        
//        func executeTask01() {
//            concurrentQueue.async {
//                var counter = 0
//                print("Task 1 started")
//                for _ in 0..<100000000 {
//                    counter += 1
//                }
//            }
//            concurrentQueue.sync {
//                print("Task 1 finished")
//            }
//            print("TASK 01 ASYNC")
//        }
//        
//        func executeTask02() {
//            concurrentQueue.async {
//                var counter = 0
//                print("Task 2 started")
//                for _ in 0..<1000000 {
//                    counter += 1
//                }
//                print("Task 2 finished")
//            }
//        }
//        
        
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
