//
//  AddNewSectionToDiscoUseCaseInput.swift
//  Domain
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation

public struct AddNewSectionToDiscoUseCaseInput {
    let sectionName: String
    let records: [Record]
    
    public init(sectionName: String, records: [Record]) {
        self.sectionName = sectionName
        self.records = records
    }
}
