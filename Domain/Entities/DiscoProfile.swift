//
//  DiscoProfile.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public struct DiscoProfile: Equatable {
    public let disco: Disco
    public let references: [AlbumReference]
    public let section: [Section]

    public init(disco: Disco, references: [AlbumReference], section: [Section]) {
        self.disco = disco
        self.references = references
        self.section = section
    }
}
