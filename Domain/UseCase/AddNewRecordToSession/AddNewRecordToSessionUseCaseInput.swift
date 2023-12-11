//
//  AddNewRecordToSessionUseCaseInput.swift
//  Domain
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation

public struct AddNewRecordToSessionUseCaseInput {
    let section: Section
    
    public init(section: Section) {
        self.section = section
    }
}
