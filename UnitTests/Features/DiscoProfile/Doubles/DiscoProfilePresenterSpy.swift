//
//  DiscoProfilePresenterSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class DiscoProfilePresenterSpy: DiscoProfilePresentationLogic {
    enum Message: Equatable {
        case presentLoading
        case presentFoundReferences(SearchReferencesPage)
        case presentFindReferencesError(String)
        case presentLoadedProfile(DiscoProfile)
        case presentLoadProfileError(String)
        case presentAddedReferences(DiscoProfile)
        case presentAddReferencesError(String)
        case presentAddedSection(DiscoProfile)
        case presentAddSectionError(String)
        case presentAddedRecord(DiscoProfile)
        case presentAddRecordError(String)
        case presentCreateSectionError(String)
    }

    private(set) var receivedMessages: [Message] = []

    func presentLoading() {
        receivedMessages.append(.presentLoading)
    }

    func presentFoundReferences(_ references: SearchReferencesPage) {
        receivedMessages.append(.presentFoundReferences(references))
    }

    func presentFindReferencesError(_ error: Error) {
        receivedMessages.append(.presentFindReferencesError(error.localizedDescription))
    }

    func presentLoadedProfile(_ profile: DiscoProfile) {
        receivedMessages.append(.presentLoadedProfile(profile))
    }

    func presentLoadProfileError(_ error: Error) {
        receivedMessages.append(.presentLoadProfileError(error.localizedDescription))
    }

    func presentAddedReferences(_ profile: DiscoProfile) {
        receivedMessages.append(.presentAddedReferences(profile))
    }

    func presentAddReferencesError(_ error: Error) {
        receivedMessages.append(.presentAddReferencesError(error.localizedDescription))
    }

    func presentAddedSection(_ profile: DiscoProfile) {
        receivedMessages.append(.presentAddedSection(profile))
    }

    func presentAddSectionError(_ error: Error) {
        receivedMessages.append(.presentAddSectionError(error.localizedDescription))
    }

    func presentAddedRecord(_ profile: DiscoProfile) {
        receivedMessages.append(.presentAddedRecord(profile))
    }

    func presentAddRecordError(_ error: Error) {
        receivedMessages.append(.presentAddRecordError(error.localizedDescription))
    }

    func presentCreateSectionError(_ error: Error) {
        receivedMessages.append(.presentCreateSectionError(error.localizedDescription))
    }
}
