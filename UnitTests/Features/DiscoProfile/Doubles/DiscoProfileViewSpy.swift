//
//  DiscoProfileViewSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class DiscoProfileViewSpy: DiscoProfileDisplayLogic {
    var hideOverlaysCompletion: (() -> Void)?


    func startLoading() {  }
    func hideLoading() {  }

    @SWSpyMethodTracker
    func hideOverlays(completion: (() -> Void)?) {
        receivedMessages.append(.hideOverlays)
        hideOverlaysCompletion = completion
    }

    func showSearchProviders(
        _ providers: [SearchReferenceViewEntity],
        selectedProvider: SearchReferenceViewEntity
    ) { }

    func showReferences(_ references: ReferenceSearchViewEntity) { }
    func showProfile(_ profile: DiscoProfileViewEntity) {}
    func updateReferences(_ references: [AlbumReferenceViewEntity]) { }
    func updateSections(_ sections: [SectionViewEntity]) { }
    func addingReferencesError(_ title: String, description: String) { }
    func addingSectionError(_ title: String, description: String) {}
    func loadingProfileError(_ title: String, description: String) {}
    func addingRecordsError(_ title: String, description: String) {}
    func discoNameUpdated(_ disco: DiscoSummary) { }
    func discoDeleted() {}
    func updatingDiscoError(_ title: String, description: String) {}
    func deletingDiscoError(_ title: String, description: String) {  }
    func deletingSectionError(_ title: String, description: String) {}
    func deletingRecordError(_ title: String, description: String) {  }
}
