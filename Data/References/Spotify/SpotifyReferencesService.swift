//
//  ReferencesServiceImpl.swift
//  Data
//
//  Created by Thiago Henrique on 08/12/23.
//

import Foundation
import Domain

public class SpotifyReferencesService: ReferencesService {
    let networkClient: NetworkClient
    
    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    public func loadReferences(
        _ keywords: String,
        completion: @escaping (Result<[AlbumReference], Error>) -> Void
    ) {
        let endpoint = GetReferencesEndpoint(keywords: keywords)
        
        networkClient.makeRequest(endpoint) { result in
            switch result {
                case .success(let data):
                    do {
                        let dataEntity = try AlbumReferenceDataEntity.loadFromData(data)
                        completion(.success(dataEntity.toDomain()))
                    } catch {
                        completion(.failure(DataError.decodingError))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
