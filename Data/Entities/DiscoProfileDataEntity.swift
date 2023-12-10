//
//  DiscoProfileDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public struct DiscoProfileDataEntity: DataEntity, Codable {
    public let disco: DiscoDataEntity
    public let references: [AlbumReferenceDataEntity]
    public let section: [SectionDataEntity]
    
    public init(disco: DiscoDataEntity, references: [AlbumReferenceDataEntity], section: [SectionDataEntity]) {
        self.disco = disco
        self.references = references
        self.section = section
    }
}
