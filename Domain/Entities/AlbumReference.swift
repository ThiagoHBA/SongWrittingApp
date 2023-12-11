//
//  AlbumReference.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public struct AlbumReference: Equatable {
    public let name: String
    public let artist: String
    public let releaseDate: String
    public let coverImage: URL
    
    public init(name: String, artist: String, releaseDate: String, coverImage: URL) {
        self.name = name
        self.artist = artist
        self.releaseDate = releaseDate
        self.coverImage = coverImage
    }
}
