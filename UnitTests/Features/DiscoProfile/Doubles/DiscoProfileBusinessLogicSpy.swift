//
//  DiscoProfileBusinessLogicSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class DiscoProfileBusinessLogicSpy: DiscoProfileBusinessLogic {
    func loadSearchProviders() {}
    func searchNewReferences(keywords: String) {}
    func selectReferenceProvider(_ provider: SearchReferenceViewEntity) {}
    func loadMoreReferences() {}
    func resetReferenceSearch() {}
    func loadProfile(for disco: DiscoSummary) {}
    func addNewReferences(for disco: DiscoSummary, references: [AlbumReferenceViewEntity]) {}
    func addNewSection(for disco: DiscoSummary, section: SectionViewEntity) {}
    func addNewRecord(in disco: DiscoSummary, to sectionIdentifier: String, audioFileURL: URL) {}
    func updateDiscoName(disco: DiscoSummary, newName: String) { }
    func deleteDisco(_ disco: DiscoSummary) { }
    func deleteSection(in disco: DiscoSummary, sectionIdentifier: String) { }
    func deleteRecord(in disco: DiscoSummary, sectionIdentifier: String, audioURL: URL) { }

    func reset() {
        receivedMessages.removeAll()
    }
}
