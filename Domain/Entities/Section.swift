//
//  Section.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public struct Section: Equatable {
    public let identifer: String
    public let records: [Record]

    public init(identifer: String, records: [Record]) {
        self.identifer = identifer
        self.records = records
    }
}
