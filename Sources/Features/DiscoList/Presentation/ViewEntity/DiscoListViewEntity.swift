import Foundation

struct DiscoListViewEntity: Equatable {
    enum DiscoListEntityType {
        case placeholder
        case disco
    }

    let id: UUID
    let name: String
    let description: String?
    let coverImage: Data
    let entityType: DiscoListEntityType

    init(id: UUID, name: String, description: String? = nil, coverImage: Data, entityType: DiscoListEntityType) {
        self.id = id
        self.name = name
        self.description = description
        self.coverImage = coverImage
        self.entityType = entityType
    }

    init(from disco: DiscoSummary) {
        self.id = disco.id
        self.name = disco.name
        self.description = disco.description
        self.coverImage = disco.coverImage
        self.entityType = .disco
    }

    func toSummary() -> DiscoSummary {
        DiscoSummary(id: id, name: name, description: description, coverImage: coverImage)
    }
}
