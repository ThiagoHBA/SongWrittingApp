//
//  RecordDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public struct RecordDataEntity: DataEntity, Codable {
    public let tag: InstrumentTagDataEntity
    public let audio: Data
    
    public init(tag: InstrumentTagDataEntity, audio: Data) {
        self.tag = tag
        self.audio = audio
    }
    
    public func toDomain() -> Record {
        return Record(
            tag: tag.toDomain(),
            audio: audio
        )
    }
}

public enum InstrumentTagDataEntity: Equatable, Codable {
    case guitar
    case vocal
    case drums
    case bass
    case custom(String)
    
    func toDomain() -> InstrumentTag {
        switch self {
            case .guitar:
                return .guitar
            case .vocal:
                return .vocal
            case .drums:
                return .drums
            case .bass:
                return .bass
            case .custom(let value):
                return .custom(value)
        }
    }
}
