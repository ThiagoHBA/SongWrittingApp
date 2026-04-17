import Foundation

struct DiscoListViewEntity: Equatable {
    let id: UUID
    let name: String
    let coverImage: Data

    init(id: UUID, name: String, coverImage: Data) {
        self.id = id
        self.name = name
        self.coverImage = coverImage
    }

    init(from disco: DiscoSummary) {
        self.id = disco.id
        self.name = disco.name
        self.coverImage = disco.coverImage
    }

    func toSummary() -> DiscoSummary {
        DiscoSummary(id: id, name: name, coverImage: coverImage)
    }
}
