//
//  AddNewSectionToDiscoUseCaseOutput.swift
//  Domain
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation

public protocol AddNewSectionToDiscoUseCaseOutput {
    func successfullyAddedSectionToDisco(_ disco: DiscoProfile)
    func errorWhileAddingSectionToDisco(_ error: Error)
}
