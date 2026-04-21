//
//  GetDiscoReferencesUseCaseSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 20/04/26.
//

import Foundation
@testable import Main

final class GetDiscoReferencesUseCaseSpy: GetDiscoReferencesUseCase {
    enum ReceivedMessage: Equatable {
        case loadReferences(DiscoSummary)
    }

    var results: [UUID: Result<GetDiscoReferencesUseCaseOutput, Error>] = [:]
    private(set) var receivedMessages: [ReceivedMessage] = []

    func loadReferences(
        _ input: GetDiscoReferencesUseCaseInput,
        completion: @escaping (Result<GetDiscoReferencesUseCaseOutput, Error>) -> Void
    ) {
        receivedMessages.append(.loadReferences(input))
        completion(results[input.id] ?? .success([]))
    }
}
