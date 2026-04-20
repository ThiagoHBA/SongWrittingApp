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
        case loadSearchProviders
        case searchNewReferences(String)
        case selectReferenceProvider(SearchReferenceViewEntity)
        case loadMoreReferences
        case resetReferenceSearch
        case loadProfile(DiscoSummary)
        case addNewReferences(DiscoSummary, [AlbumReferenceViewEntity])
        case addNewSection(DiscoSummary, SectionViewEntity)
        case addNewRecord(DiscoSummary, String, URL)
        case updateDiscoName(DiscoSummary, String)
        case deleteDisco(DiscoSummary)
        case deleteSection(DiscoSummary, String)
        case deleteRecord(DiscoSummary, String, URL)
    }

    private(set) var receivedMessages: [Message] = []

    func loadSearchProviders() {
        receivedMessages.append(.loadSearchProviders)
    }

    func searchNewReferences(keywords: String) {
        receivedMessages.append(.searchNewReferences(keywords))
    }

    func selectReferenceProvider(_ provider: SearchReferenceViewEntity) {
        receivedMessages.append(.selectReferenceProvider(provider))
    }

    func loadMoreReferences() {
        receivedMessages.append(.loadMoreReferences)
    }

    func resetReferenceSearch() {
        receivedMessages.append(.resetReferenceSearch)
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

    func addNewRecord(in disco: DiscoSummary, to sectionIdentifier: String, audioFileURL: URL) {
        receivedMessages.append(.addNewRecord(disco, sectionIdentifier, audioFileURL))
    }

    func updateDiscoName(disco: DiscoSummary, newName: String) {
        receivedMessages.append(.updateDiscoName(disco, newName))
    }

    func deleteDisco(_ disco: DiscoSummary) {
        receivedMessages.append(.deleteDisco(disco))
    }

    func deleteSection(in disco: DiscoSummary, sectionIdentifier: String) {
        receivedMessages.append(.deleteSection(disco, sectionIdentifier))
    }

    func deleteRecord(in disco: DiscoSummary, sectionIdentifier: String, audioURL: URL) {
        receivedMessages.append(.deleteRecord(disco, sectionIdentifier, audioURL))
    }

    func reset() {
        receivedMessages.removeAll()
    }
}
