//
//  DiscoDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public struct DiscoStoreRecord: StoreRecord, Codable, Equatable {
    public let id: UUID
    public let name: String
    public let description: String?
    public let coverImage: Data

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case coverImage
    }

    public init(id: UUID, name: String, description: String? = nil, coverImage: Data) {
        self.id = id
        self.name = name
        self.description = description
        self.coverImage = coverImage
    }
}
