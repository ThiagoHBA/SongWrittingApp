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
    var albums: Albums

    public func toDomain() -> [AlbumReference] {
        return albums.items.map {
            AlbumReference(
                name: $0.name,
                artist: $0.artists.first?.name ?? "",
                releaseDate: $0.releaseDate,
                coverImage: $0.images.first?.url ?? ""
            )
        }
    }

    public init(albums: Albums) {
        self.albums = albums
    }

    public init(from domain: [AlbumReference]) {
        self.albums = .init(
            items: domain.map {
                .init(
                    artists: [Artist(name: $0.artist)],
                    images: [Image(height: 0, url: $0.coverImage, width: 0)],
                    name: $0.name,
                    releaseDate: $0.releaseDate
                )
            }
        )
    }
}

public struct Albums: Codable {
    var items: [Item]
}

public struct Item: Codable {
    let artists: [Artist]
    let images: [Image]
    let name, releaseDate: String

    enum CodingKeys: String, CodingKey {
        case artists
        case images, name
        case releaseDate = "release_date"
    }
}

public struct Artist: Codable {
    let name: String
}

public struct Image: Codable {
    let height: Int
    let url: String
    let width: Int
}
