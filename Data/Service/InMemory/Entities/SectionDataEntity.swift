//
//  SectionDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public struct SectionDataEntity: DataEntity, Codable, Equatable {
    public let identifer: String
    public var records: [RecordDataEntity]

    public init(identifer: String, records: [RecordDataEntity]) {
        self.identifer = identifer
        self.records = records
    }

    internal init(from domain: Section) {
        self.identifer = domain.identifer
        self.records = domain.records.map { RecordDataEntity(from: $0) }
    }

    public func toDomain() -> Section {
        return Section(
            identifer: identifer,
            records: records.map { $0.toDomain() }
        )
    }
}
