//
//  ReferenceServiceSpy.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation
import Domain

final class ReferenceServiceSpy {
    private(set) var receivedMessages: [Message] = [Message]()
    var loadReferencesCompletion: ((Result<[AlbumReference], Error>) -> Void)?

    enum Message: Equatable, CustomStringConvertible {
        case loadReferences(String)

        var description: String {
            switch self {
            case .loadReferences(let data):
                return "loadReferences Called with data: \(data)"
            }
        }
    }
}

extension ReferenceServiceSpy: ReferencesService {
    func loadReferences(
        _ keywords: String,
        completion: @escaping (Result<[AlbumReference], Error>) -> Void
    ) {
        loadReferencesCompletion = completion
        receivedMessages.append(.loadReferences(keywords))
    }
}
