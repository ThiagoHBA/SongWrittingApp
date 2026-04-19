//
//  DiscoProfileBusinessLogicSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class DiscoProfileBusinessLogicSpy: DiscoProfileBusinessLogic {
    enum Message: Equatable {
        case searchNewReferences(String)
        case loadProfile(DiscoSummary)
        case addNewReferences(DiscoSummary, [AlbumReferenceViewEntity])
        case addNewSection(DiscoSummary, SectionViewEntity)
        case addNewRecord(DiscoSummary, SectionViewEntity)
    }

    private(set) var receivedMessages: [Message] = []

    func searchNewReferences(keywords: String) {
        receivedMessages.append(.searchNewReferences(keywords))
    }

    func loadProfile(for disco: DiscoSummary) {
        receivedMessages.append(.loadProfile(disco))
    }

    func addNewReferences(for disco: DiscoSummary, references: [AlbumReferenceViewEntity]) {
        receivedMessages.append(.addNewReferences(disco, references))
    }

    func addNewSection(for disco: DiscoSummary, section: SectionViewEntity) {
        receivedMessages.append(.addNewSection(disco, section))
    }

    func addNewRecord(in disco: DiscoSummary, to section: SectionViewEntity) {
        receivedMessages.append(.addNewRecord(disco, section))
    }

    func reset() {
        receivedMessages.removeAll()
    }
}
