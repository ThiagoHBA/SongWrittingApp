import Foundation

struct DiscoListViewEntity: Equatable {
    enum DiscoListEntityType {
        case placeholder
        case disco
    }
    
    let id: UUID
    let name: String
    let coverImage: Data
    let entityType: DiscoListEntityType

    init(id: UUID, name: String, coverImage: Data, entityType: DiscoListEntityType) {
        self.id = id
        self.name = name
        self.coverImage = coverImage
        self.entityType = entityType
    }

    init(from disco: DiscoSummary) {
        self.id = disco.id
        self.name = disco.name
        self.coverImage = disco.coverImage
        self.entityType = .disco
    }

    func toSummary() -> DiscoSummary {
        DiscoSummary(id: id, name: name, coverImage: coverImage)
    }
}
