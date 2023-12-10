//
//  AlbumReferenceEntity.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public struct AlbumReferenceViewEntity {
    public let name: String
    public let artist: String
    public let releaseDate: String
    
    public init(name: String, artist: String, releaseDate: String) {
        self.name = name
        self.artist = artist
        self.releaseDate = releaseDate
    }
    
    internal init(from domain: AlbumReference) {
        self.name = domain.name
        self.artist = domain.artist
        self.releaseDate = domain.releaseDate
    }
}
