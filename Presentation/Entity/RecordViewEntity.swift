//
//  RecordViewEntity.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Domain

public struct RecordViewEntity: Equatable {
    public var tag: String
    public let audio: Data
    
    public init(tag: String, audio: Data) {
        self.tag = tag
        self.audio = audio
    }
    
    internal init(from domain: Record) {
        self.tag = ""
        self.audio = domain.audio
        
        self.tag = getTagValueFromDomain(domain.tag)
    }
    
    private func getTagValueFromDomain(_ tag: InstrumentTag) -> String {
        switch tag {
            case .guitar:
                return "Guitarra"
            case .vocal:
                return "Voz"
            case .drums:
                return "Bateria"
            case .bass:
                return "Baixo"
            case .custom(let customValue):
                return "\(customValue)"
        }
    }
}

