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
    public let coverImage: String
    
    public init(id: UUID, name: String, coverImage: String) {
        self.id = id
        self.name = name
        self.coverImage = coverImage
    }
}
