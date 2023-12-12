//
//  GetDiscoProfileUseCaseInput.swift
//  Domain
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation

public struct GetDiscoProfileUseCaseInput {
    public let disco: Disco

    public init(disco: Disco) {
        self.disco = disco
    }
}
