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
    public let audio: URL
    
    public init(tag: InstrumentTagDataEntity, audio: URL) {
        self.tag = tag
        self.audio = audio
    }
    
    internal init(from domain: Record) {
        self.tag = InstrumentTagDataEntity(from: domain.tag)
        self.audio = domain.audio
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
    
    public init(from domain: InstrumentTag) {
        switch domain {
            case .guitar:
                self = .guitar
            case .vocal:
                self = .vocal
            case .drums:
                self = .drums
            case .bass:
                self = .bass
            case .custom(let value):
                self = .custom(value)
        }
    }
    
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
