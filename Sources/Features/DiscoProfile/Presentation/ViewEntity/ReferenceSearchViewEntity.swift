import Foundation

struct ReferenceSearchViewEntity: Equatable {
    let references: [AlbumReferenceViewEntity]
    let hasMore: Bool

    init(references: [AlbumReferenceViewEntity], hasMore: Bool) {
        self.references = references
        self.hasMore = hasMore
    }

    init(from domain: SearchReferencesPage) {
        self.references = domain.references.map(AlbumReferenceViewEntity.init(from:))
        self.hasMore = domain.hasMore
    }
}
