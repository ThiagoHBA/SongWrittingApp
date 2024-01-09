//
//  DiscoService.swift
//  Data
//
//  Created by Thiago Henrique on 16/12/23.
//

import Foundation
import Domain

public final class DiscoServiceImpl: DiscoService {
    let storage: DiscoDataStorage
    
    public init(storage: DiscoDataStorage) {
        self.storage = storage
    }
    
    public func createDisco(
        name: String,
        image: Data,
        completion: @escaping (Result<Disco, Error>) -> Void
    ) {
        let disco = DiscoDataEntity(id: UUID(), name: name, coverImage: image)
        storage.getDiscos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let discos):
                if discos.contains(where: { $0.name == disco.name }) {
                    completion(.failure(DataError.nameAlreadyExist))
                    return
                } else {
                    self.storage.createDisco(disco) { result in
                        switch result {
                        case .success(let createdDisco):
                            completion(.success(createdDisco.toDomain()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    return
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func loadDiscos(
        completion: @escaping (Result<[Disco], Error>) -> Void
    ) {
        storage.getDiscos { result in
            switch result {
            case .success(let discos):
                completion(.success(discos.map { $0.toDomain() }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func loadProfile(
        for disco: Disco,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        storage.getProfiles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profiles):
                guard let profileIndex = profiles.firstIndex(
                    where: {
                        $0.disco.toDomain() == disco
                    }
                ) else {
                    let profile = DiscoProfileDataEntity.createEmptyProfile(for: disco)
                    self.storage.createProfile(profile) { result in
                        switch result {
                        case .success(let profile):
                            completion(.success(profile.toDomain()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    return
                }
                completion(.success(profiles[profileIndex].toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func updateDiscoReferences(
        _ disco: Disco,
        references: [AlbumReference],
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        storage.getProfiles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profiles):
                guard let profileIndex = profiles.firstIndex(
                    where: {
                        $0.disco.id == disco.id
                    }
                ) else {
                    completion(.failure(DataError.cantFindDisco))
                    return
                }
                var updatedProfile = profiles[profileIndex]
                let dataReferences = AlbumReferenceDataEntity(from: references)
                updatedProfile.references = dataReferences
                storage.updateProfile(updatedProfile) { result in
                    switch result {
                    case .success(let updatedProfile):
                        completion(.success(updatedProfile.toDomain()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addNewSection(
        _ disco: Disco,
        _ section: Section,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        storage.getProfiles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profiles):
                guard let discoProfileIndex = profiles.firstIndex(
                    where: { $0.disco.id == disco.id}
                ) else {
                    completion(.failure(DataError.cantFindDisco))
                    return
                }
                var mutatedProfile = profiles[discoProfileIndex]
                mutatedProfile.section.append(SectionDataEntity(from: section))
                self.storage.updateProfile(mutatedProfile) { result in
                    switch result {
                    case .success(let profile):
                        completion(.success(profile.toDomain()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addNewRecord(
        _ disco: Disco,
        _ section: Section,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    ) {
        storage.getProfiles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profiles):
                guard let discoProfileIndex = profiles.firstIndex(
                    where: { $0.disco.id == disco.id}
                ) else {
                    completion(.failure(DataError.cantFindDisco))
                    return
                }
                var mutatedProfile = profiles[discoProfileIndex]
                guard let sectionIndex = mutatedProfile.section.firstIndex(
                    where: {
                        $0.identifer == section.identifer
                    }
                ) else {
                    completion(.failure(DataError.cantFindSection))
                    return
                }
                mutatedProfile.section[sectionIndex] = SectionDataEntity(from: section)
                storage.updateProfile(mutatedProfile) { result in
                    switch result {
                    case .success(let profile):
                        completion(.success(profile.toDomain()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    return
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}
