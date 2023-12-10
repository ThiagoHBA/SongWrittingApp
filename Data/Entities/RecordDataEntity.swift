//
//  RecordDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public struct RecordDataEntity: DataEntity, Codable {
    public let tag: InstrumentTagDataEntity
    public let audio: Data
    
    public init(tag: InstrumentTagDataEntity, audio: Data) {
        self.tag = tag
        self.audio = audio
    }
}

public enum InstrumentTagDataEntity: Equatable, Codable {
    case guitar
    case vocal
    case drums
    case bass
    case custom(String)
}
