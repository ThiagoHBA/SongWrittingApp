import Foundation

struct AlbumReferenceDTO: StoreRecord, Codable, Equatable {
    let albums: Albums

    func mapReferences() -> [AlbumReference] {
        albums.items.map {
            AlbumReference(
                name: $0.name,
                artist: $0.artists.first?.name ?? "",
                releaseDate: $0.releaseDate,
                coverImage: $0.images.first?.url ?? ""
            )
        }
    }
}

struct Albums: Codable, Equatable {
    let items: [AlbumItem]
    let limit: Int
    let offset: Int
    let total: Int
}

struct AlbumItem: Codable, Equatable {
    let artists: [AlbumArtist]
    let images: [AlbumImage]
    let name: String
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case artists
        case images
        case name
        case releaseDate = "release_date"
    }
}

struct AlbumArtist: Codable, Equatable {
    let name: String
}

struct AlbumImage: Codable, Equatable {
    let height: Int
    let url: String
    let width: Int
}
