//
//  CreateNewDiscoUseCaseOutput.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public protocol CreateNewDiscoUseCaseOutput {
    func successfullyCreateDisco(_ disco: Disco)
    func errorWhileCreatingDisco(_ error: Error)
}
