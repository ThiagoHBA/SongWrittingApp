import Foundation

struct DiscoProfile: Equatable {
    let disco: DiscoSummary
    var references: [AlbumReference]
    var section: [Section]
}
