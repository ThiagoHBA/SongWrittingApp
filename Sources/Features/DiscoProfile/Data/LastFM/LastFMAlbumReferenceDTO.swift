//
//  LastFMAlbumReferenceDTO.swift
//  Main
//
//  Created by Thiago Henrique on 19/04/26.
//

import Foundation

struct LastFMAlbumReferenceDTO: StoreRecord, Codable, Equatable {
    let results: LastFMAlbumSearchResultsDTO

    func mapPage() -> SearchReferencesPage {
        let references = results.albumMatches.albums.map {
            AlbumReference(
                name: $0.name,
                artist: $0.artist,
                releaseDate: "",
                coverImage: $0.images.last(where: { !$0.text.isEmpty })?.text ?? ""
            )
        }
        let hasMore = results.startIndex + references.count < results.totalResults

        return SearchReferencesPage(
            references: references,
            hasMore: hasMore
        )
    }
}

struct LastFMAlbumSearchResultsDTO: Codable, Equatable {
    let albumMatches: LastFMAlbumMatchesDTO
    let totalResultsValue: String
    let startIndexValue: String

    var totalResults: Int {
        Int(totalResultsValue) ?? 0
    }

    var startIndex: Int {
        Int(startIndexValue) ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case albumMatches = "albummatches"
        case totalResultsValue = "opensearch:totalResults"
        case startIndexValue = "opensearch:startIndex"
    }
}

struct LastFMAlbumMatchesDTO: Codable, Equatable {
    let albums: [LastFMAlbumMatchDTO]

    enum CodingKeys: String, CodingKey {
        case albums = "album"
    }
}

struct LastFMAlbumMatchDTO: Codable, Equatable {
    let name: String
    let artist: String
    let images: [LastFMAlbumImageDTO]

    enum CodingKeys: String, CodingKey {
        case name
        case artist
        case images = "image"
    }
}

struct LastFMAlbumImageDTO: Codable, Equatable {
    let text: String

    enum CodingKeys: String, CodingKey {
        case text = "#text"
    }
}
