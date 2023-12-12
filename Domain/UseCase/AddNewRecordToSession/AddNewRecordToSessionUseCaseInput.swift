//
//  AddNewRecordToSessionUseCaseInput.swift
//  Domain
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation

public struct AddNewRecordToSessionUseCaseInput {
    let disco: Disco
    let section: Section

    public init(disco: Disco, section: Section) {
        self.disco = disco
        self.section = section
    }
}
