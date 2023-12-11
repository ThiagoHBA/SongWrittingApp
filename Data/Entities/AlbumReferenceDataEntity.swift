//
//  AlbumReferenceDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain


// MARK: - Models from spotify API
public struct AlbumReferenceDataEntity: DataEntity, Codable {
    let albums: Albums
    
    func toDomain() -> [AlbumReference] {
        return albums.items.map {
            AlbumReference(
                name: $0.name,
                artist: $0.artists.first?.name ?? "",
                releaseDate: $0.releaseDate,
                coverImage:  $0.images.first?.url ?? ""
            )
        }
    }
}

struct Albums: Codable {
    let items: [Item]
}

struct Item: Codable {
    let artists: [Artist]
    let id: String
    let images: [Image]
    let name, releaseDate: String

    enum CodingKeys: String, CodingKey {
        case artists
        case id, images, name
        case releaseDate = "release_date"
    }
}

struct Artist: Codable {
    let name: String
}

struct Image: Codable {
    let height: Int
    let url: String
    let width: Int
}
