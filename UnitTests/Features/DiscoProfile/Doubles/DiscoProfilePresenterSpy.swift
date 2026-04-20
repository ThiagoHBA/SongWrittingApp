//
//  DiscoProfilePresenterSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
import SongWrittingMacros
@testable import Main

@SWSpy
final class DiscoProfilePresenterSpy: DiscoProfilePresentationLogic {

    func presentLoading() { }
    func presentSearchProviders(
        _ providers: [SearchReferenceViewEntity],
        selectedProvider: SearchReferenceViewEntity
    ) {}

    func presentFoundReferences(_ references: SearchReferencesPage) {}
    func presentFindReferencesError(_ error: Error) { }
    func presentLoadedProfile(_ profile: DiscoProfile) {}
    func presentLoadProfileError(_ error: Error) { }
    func presentAddedReferences(_ profile: DiscoProfile) {}
    func presentAddReferencesError(_ error: Error) {}
    func presentAddedSection(_ profile: DiscoProfile) { }
    func presentAddSectionError(_ error: Error) { }
    func presentAddedRecord(_ profile: DiscoProfile) { }
    func presentAddRecordError(_ error: Error) { }
    func presentCreateSectionError(_ error: Error) { }
    func presentDiscoNameUpdated(_ disco: DiscoSummary) { }
    func presentUpdateDiscoNameError(_ error: Error) { }
    func presentDiscoDeleted() { }
    func presentDeleteDiscoError(_ error: Error) { }
    func presentSectionDeleted(_ profile: DiscoProfile) { }
    func presentDeleteSectionError(_ error: Error) { }
    func presentRecordDeleted(_ profile: DiscoProfile) {  }
    func presentDeleteRecordError(_ error: Error) {}
}
