//
//  DiscoDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public struct DiscoDataEntity: DataEntity, Codable {
    let id: UUID
    let name: String
    let coverImage: Data
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coverImage
    }
    
    public init(id: UUID, name: String, coverImage: Data) {
        self.id = id
        self.name = name
        self.coverImage = coverImage
    }
    
    public init(from disco: Disco) {
        self.id = disco.id
        self.name = disco.name
        self.coverImage = disco.coverImage
    }
    
    func toDomain() -> Disco {
        return Disco(id: id, name: name, coverImage: coverImage)
    }
}
