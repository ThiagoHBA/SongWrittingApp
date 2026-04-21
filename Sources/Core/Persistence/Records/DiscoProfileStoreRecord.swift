//
//  DiscoProfileDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public struct DiscoProfileStoreRecord: StoreRecord, Codable, Equatable {
    public let disco: DiscoStoreRecord
    public var references: [AlbumReferenceStoreRecord]
    public var section: [SectionStoreRecord]

    public init(
        disco: DiscoStoreRecord,
        references: [AlbumReferenceStoreRecord],
        section: [SectionStoreRecord]
    ) {
        self.disco = disco
        self.references = references
        self.section = section
    }
}
