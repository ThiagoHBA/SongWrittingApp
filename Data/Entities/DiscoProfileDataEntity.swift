//
//  DiscoProfileDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public struct DiscoProfileDataEntity: DataEntity, Codable {
    public let disco: DiscoDataEntity
    public var references: AlbumReferenceDataEntity
    public let section: [SectionDataEntity]
    
    public init(disco: DiscoDataEntity, references: AlbumReferenceDataEntity, section: [SectionDataEntity]) {
        self.disco = disco
        self.references = references
        self.section = section
    }
    
    public func toDomain() -> DiscoProfile {
        return DiscoProfile(
            disco: disco.toDomain(),
            references: references.toDomain(),
            section: section.map { $0.toDomain() }
        )
    }
}
