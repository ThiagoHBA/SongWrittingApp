//
//  RecordViewEntity.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public struct RecordViewEntity: Equatable {
    public var tag: InstrumentTagViewEntity
    public let audio: Data
    
    public init(tag: InstrumentTagViewEntity, audio: Data) {
        self.tag = tag
        self.audio = audio
    }
    
    internal init(from domain: Record) {
        self.tag = InstrumentTagViewEntity(from: domain.tag)
        self.audio = domain.audio
    }
    
    func toDomain() -> Record {
        return Record(
            tag: tag.toDomain(),
            audio: audio
        )
    }
}

public enum InstrumentTagViewEntity: String {
    case guitar = "Guitarra"
    case vocal = "Voz"
    case drums = "Bateria"
    case bass = "Baixo"
    case custom
    
    init(from domain: InstrumentTag) {
        switch domain {
            case .guitar:
                self = .guitar
            case .vocal:
                self = .vocal
            case .drums:
                self = .drums
            case .bass:
                self = .bass
            case .custom(_):
                self = .custom
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
            case .custom:
                return .custom("")
        }
    }
}
