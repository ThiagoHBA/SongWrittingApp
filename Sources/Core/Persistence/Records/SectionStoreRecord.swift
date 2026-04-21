//
//  SectionDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public struct SectionStoreRecord: StoreRecord, Codable, Equatable {
    public let identifer: String
    public var records: [RecordStoreRecord]

    public init(identifer: String, records: [RecordStoreRecord]) {
        self.identifer = identifer
        self.records = records
    }
}
