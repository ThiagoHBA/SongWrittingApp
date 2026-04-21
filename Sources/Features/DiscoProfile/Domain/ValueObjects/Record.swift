import Foundation

struct Record: Equatable {
    let tag: InstrumentTag
    let audio: URL
}

enum InstrumentTag: Equatable {
    case guitar
    case vocal
    case drums
    case bass
    case custom(String)
}
