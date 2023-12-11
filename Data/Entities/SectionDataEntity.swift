//
//  SectionDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public struct SectionDataEntity: DataEntity, Codable {
    public let identifer: String
    public let records: [RecordDataEntity]
    
    public init(identifer: String, records: [RecordDataEntity]) {
        self.identifer = identifer
        self.records = records
    }
    
    public func toDomain() -> Section {
        return Section(
            identifer: identifer,
            records: records.map { $0.toDomain() }
        )
    }
}
