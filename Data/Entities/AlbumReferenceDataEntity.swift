//
//  AlbumReferenceDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public struct AlbumReferenceDataEntity: DataEntity, Codable {
    public let name: String
    public let artist: String
    public let releaseDate: String
    
    public init(name: String, artist: String, releaseDate: String) {
        self.name = name
        self.artist = artist
        self.releaseDate = releaseDate
    }
}
