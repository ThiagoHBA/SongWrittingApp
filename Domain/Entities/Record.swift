//
//  Record.swift
//  Domain
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public struct Record: Equatable {
    public let tag: InstrumentTag
    public let audio: String
    
    public init(tag: InstrumentTag, audio: String) {
        self.tag = tag
        self.audio = audio
    }
}

public enum InstrumentTag: Equatable {
    case guitar
    case vocal
    case drums
    case bass
    case custom(String)
}
