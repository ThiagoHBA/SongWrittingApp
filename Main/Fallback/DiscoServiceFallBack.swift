//
//  DiscoServiceFallBack.swift
//  Main
//
//  Created by Thiago Henrique on 12/12/23.
//

import Foundation
import Domain

final class DiscoServiceFallBack: DiscoService {
    let primary: DiscoService
    let secundary: DiscoService
    
    init(primary: DiscoService, secundary: DiscoService) {
        self.primary = primary
        self.secundary = secundary
    }
    
    func createDisco(name: String, image: Data, completion: @escaping (Result<Disco, Error>) -> Void) {
        primary.createDisco(name: name, image: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(FallbackError.primaryFailed))
                secundary.createDisco(name: name, image: image, completion: completion)
            }
        }
    }
    
    func loadDiscos(completion: @escaping (Result<[Domain.Disco], Error>) -> Void) {
        primary.loadDiscos { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    secundary.loadDiscos(completion: completion)
            }
        }
    }
    
    func loadProfile(for disco: Disco, completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
        primary.loadProfile(for: disco) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    secundary.loadProfile(for: disco, completion: completion)
            }
        }
    }
    
    func updateDiscoReferences(_ disco: Disco, references: [AlbumReference], completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
        primary.updateDiscoReferences(disco, references: references) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    secundary.updateDiscoReferences(disco, references: references, completion: completion)
            }
        }
    }
    
    func addNewSection(_ disco: Disco, _ section: Section, completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
        primary.addNewSection(disco, section) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    secundary.addNewSection(disco, section, completion: completion)
            }
        }
    }
    
    func addNewRecord(_ disco: Disco, _ section: Section, completion: @escaping (Result<DiscoProfile, Error>) -> Void) {
        primary.addNewRecord(disco, section) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    secundary.addNewRecord(disco, section, completion: completion)
            }
        }
    }
}
