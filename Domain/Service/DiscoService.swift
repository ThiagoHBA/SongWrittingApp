//
//  DiscoService.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public protocol DiscoService {
    func createDisco(
        name: String,
        image: Data,
        completion: @escaping (Result<Disco, Error>) -> Void
    )
    
    func loadDiscos(completion: @escaping (Result<[Disco], Error>) -> Void)
    
    func loadProfile(
        for disco: Disco,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    )
    
    func updateDiscoReferences(
        _ disco: Disco,
        references: [AlbumReference],
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    )
    
    func addNewSection(
        _ disco: Disco,
        _ section: Section,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    )
    
    func addNewRecord(
        _ disco: Disco,
        _ section: Section,
        completion: @escaping (Result<DiscoProfile, Error>) -> Void
    )
}
