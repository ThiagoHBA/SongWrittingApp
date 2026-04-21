//
//  RecordDataEntity.swift
//  Data
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public struct RecordStoreRecord: StoreRecord, Codable, Equatable {
    public let tag: InstrumentTagStoreRecord
    public let audio: URL

    public init(tag: InstrumentTagStoreRecord, audio: URL) {
        self.tag = tag
        self.audio = audio
    }
}

public enum InstrumentTagStoreRecord: Equatable, Codable {
    case guitar
    case vocal
    case drums
    case bass
    case custom(String)
}
