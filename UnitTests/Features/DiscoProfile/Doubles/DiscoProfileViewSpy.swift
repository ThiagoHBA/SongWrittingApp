//
//  DiscoProfileViewSpy.swift
//  SongWrittingApp
//
//  Created by Thiago Henrique on 18/04/26.
//

import Foundation
@testable import Main

final class DiscoProfileViewSpy: DiscoProfileDisplayLogic {
    enum Message: Equatable {
        case startLoading
        case hideLoading
        case hideOverlays
        case showReferences([AlbumReferenceViewEntity])
        case showProfile(DiscoProfileViewEntity)
        case updateReferences([AlbumReferenceViewEntity])
        case updateSections([SectionViewEntity])
        case addingReferencesError(String, String)
        case addingSectionError(String, String)
        case loadingProfileError(String, String)
        case addingRecordsError(String, String)
    }

    private(set) var receivedMessages: [Message] = []
    var hideOverlaysCompletion: (() -> Void)?

    func startLoading() {
        receivedMessages.append(.startLoading)
    }

    func hideLoading() {
        receivedMessages.append(.hideLoading)
    }

    func hideOverlays(completion: (() -> Void)?) {
        receivedMessages.append(.hideOverlays)
        hideOverlaysCompletion = completion
    }

    func showReferences(_ references: [AlbumReferenceViewEntity]) {
        receivedMessages.append(.showReferences(references))
    }

    func showProfile(_ profile: DiscoProfileViewEntity) {
        receivedMessages.append(.showProfile(profile))
    }

    func updateReferences(_ references: [AlbumReferenceViewEntity]) {
        receivedMessages.append(.updateReferences(references))
    }

    func updateSections(_ sections: [SectionViewEntity]) {
        receivedMessages.append(.updateSections(sections))
    }

    func addingReferencesError(_ title: String, description: String) {
        receivedMessages.append(.addingReferencesError(title, description))
    }

    func addingSectionError(_ title: String, description: String) {
        receivedMessages.append(.addingSectionError(title, description))
    }

    func loadingProfileError(_ title: String, description: String) {
        receivedMessages.append(.loadingProfileError(title, description))
    }

    func addingRecordsError(_ title: String, description: String) {
        receivedMessages.append(.addingRecordsError(title, description))
    }
}
