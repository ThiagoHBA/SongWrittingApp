//
//  DiscoProfileViewEntity.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public struct DiscoProfileViewEntity: Equatable {
    public let disco: DiscoListViewEntity
    public let references: [AlbumReferenceViewEntity]
    public var section: [SectionViewEntity]

    public init(
        disco: DiscoListViewEntity,
        references: [AlbumReferenceViewEntity],
        section: [SectionViewEntity]
    ) {
        self.disco = disco
        self.references = references
        self.section = section
    }

    internal init(from domain: DiscoProfile) {
        self.disco = DiscoListViewEntity(from: domain.disco)
        self.references = domain.references.map { AlbumReferenceViewEntity(from: $0 )}
        self.section = domain.section.map { SectionViewEntity(from: $0) }
    }

    public func mapToDomain() -> DiscoProfile {
        return DiscoProfile(
            disco: disco.mapToDomain(),
            references: references.map { $0.mapToDomain() },
            section: section.map { $0.mapToDomain() }
        )
    }
}
