//
//  GetDiscoProfileUseCaseOutput.swift
//  Domain
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation

public protocol GetDiscoProfileUseCaseOutput {
    func succesfullyLoadProfile(_ profile: DiscoProfile)
    func errorWhileLoadingProfile(_ error: Error)
}
