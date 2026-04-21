//
//  FileManagerServiceSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 20/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

final class FileManagerServiceSpy: FileManagerService {
    enum Message: Equatable {
        case persistFile(URL)
    }

    private(set) var receivedMessages: [Message] = []
    var persistFileResult: Result<URL, Error>?

    func persistFile(at sourceURL: URL) throws -> URL {
        receivedMessages.append(.persistFile(sourceURL))
        return try persistFileResult?.get() ?? sourceURL
    }
}
