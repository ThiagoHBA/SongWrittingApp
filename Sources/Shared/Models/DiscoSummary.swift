//
//  DiscoSummary.swift
//  Main
//
//  Created by Thiago Henrique on 17/04/26.
//

import Foundation

public struct DiscoSummary: Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let coverImage: Data

    public init(id: UUID, name: String, coverImage: Data) {
        self.id = id
        self.name = name
        self.coverImage = coverImage
    }
}
