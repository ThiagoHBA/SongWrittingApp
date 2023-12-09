//
//  DiscoServiceImpl.swift
//  Data
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation
import Domain

private struct MemoryDiscoDatabase {
    var discos: [Disco] = []
    var profiles: [DiscoProfile] = []
}

public final class DiscoServiceImpl: DiscoService {
    private var memoryDatabase = MemoryDiscoDatabase()
    let networkClient: NetworkClient
    
    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    public func createDisco(
        name: String,
        image: String,
        completion: @escaping (Result<Disco, Error>) -> Void
    ) {
        let newDisco = Disco(id: UUID(), name: name, coverImage: image)
        memoryDatabase.discos.append(newDisco)
        completion(.success(newDisco))
    }
}
