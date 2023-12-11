//
//  AddNewRecordToSessionUseCaseOutput.swift
//  Domain
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation

protocol AddNewRecordToSessionUseCaseOutput {
    func successfullyAddedNewRecordToSection(_ profile: DiscoProfile)
    func errorWhileAddingNewRecordToSection(_ error: Error)
}
