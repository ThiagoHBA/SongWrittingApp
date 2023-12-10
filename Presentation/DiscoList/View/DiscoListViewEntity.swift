//
//  DiscoListViewEntity.swift
//  Presentation
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation
import Domain

public struct DiscoListViewEntity {
    public let id: UUID
    public let name: String
    public let coverImage: Data
    
    public init(id: UUID, name: String, coverImage: Data) {
        self.id = id
        self.name = name
        self.coverImage = coverImage
    }
    
    internal init(from disco: Disco) {
        self.id = disco.id
        self.name = disco.name
        self.coverImage = disco.coverImage
    }
}
