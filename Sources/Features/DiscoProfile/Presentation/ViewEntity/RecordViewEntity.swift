import Foundation

struct RecordViewEntity: Equatable {
    var tag: InstrumentTagViewEntity
    let audio: URL

    init(tag: InstrumentTagViewEntity, audio: URL) {
        self.tag = tag
        self.audio = audio
    }

    init(from domain: Record) {
        self.tag = InstrumentTagViewEntity(from: domain.tag)
        self.audio = domain.audio
    }

    func toDomain() -> Record {
        Record(tag: tag.toDomain(), audio: audio)
    }
}

enum InstrumentTagViewEntity: String {
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
        case .custom:
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
