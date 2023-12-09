//
//  Disco.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public struct Disco: Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let coverImage: Data
    
    public init(id: UUID, name: String, coverImage: Data) {
        self.id = id
        self.name = name
        self.coverImage = coverImage
    }
}
