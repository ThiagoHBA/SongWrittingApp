//
//  GetDiscosUseCaseOutput.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public protocol GetDiscosUseCaseOutput {
    func successfullyLoadDiscos(_ discos: [Disco])
    func errorWhileLoadingDiscos(_ error: Error)
}
