//
//  SectionViewEntity.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public struct SectionViewEntity: Equatable {
    public let identifer: String
    public var records: [RecordViewEntity]
    
    public init(identifer: String, records: [RecordViewEntity]) {
        self.identifer = identifer
        self.records = records
    }
    
    internal init(from domain: Section) {
        self.identifer = domain.identifer
        self.records = domain.records.map { RecordViewEntity(from: $0) }
    }
    
    public func mapToDomain() -> Section {
        return Section(
            identifer: identifer,
            records: records.map { $0.toDomain() }
        )
    }
}

