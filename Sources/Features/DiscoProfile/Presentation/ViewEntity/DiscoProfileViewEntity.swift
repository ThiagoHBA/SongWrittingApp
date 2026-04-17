import Foundation

struct DiscoProfileViewEntity: Equatable {
    let disco: DiscoSummary
    let references: [AlbumReferenceViewEntity]
    var section: [SectionViewEntity]

    init(
        disco: DiscoSummary,
        references: [AlbumReferenceViewEntity],
        section: [SectionViewEntity]
    ) {
        self.disco = disco
        self.references = references
        self.section = section
    }

    init(from domain: DiscoProfile) {
        self.disco = domain.disco
        self.references = domain.references.map(AlbumReferenceViewEntity.init(from:))
        self.section = domain.section.map(SectionViewEntity.init(from:))
    }
}
