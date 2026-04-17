import Foundation

struct AlbumReferenceViewEntity: Equatable {
    let name: String
    let artist: String
    let releaseDate: String
    let coverImage: URL?

    init(name: String, artist: String, releaseDate: String, coverImage: URL?) {
        self.name = name
        self.artist = artist
        self.releaseDate = releaseDate
        self.coverImage = coverImage
    }

    init(from domain: AlbumReference) {
        self.name = domain.name
        self.artist = domain.artist
        self.releaseDate = domain.releaseDate
        self.coverImage = URL(string: domain.coverImage)
    }

    func mapToDomain() -> AlbumReference {
        AlbumReference(
            name: name,
            artist: artist,
            releaseDate: releaseDate,
            coverImage: coverImage?.absoluteString ?? ""
        )
    }
}
