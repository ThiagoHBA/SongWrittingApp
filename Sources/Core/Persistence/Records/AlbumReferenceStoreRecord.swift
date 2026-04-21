//
//  AlbumReferenceDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public struct AlbumReferenceStoreRecord: StoreRecord, Codable, Equatable {
    public let name: String
    public let artist: String
    public let releaseDate: String
    public let coverImage: String

    public init(name: String, artist: String, releaseDate: String, coverImage: String) {
        self.name = name
        self.artist = artist
        self.releaseDate = releaseDate
        self.coverImage = coverImage
    }
}
