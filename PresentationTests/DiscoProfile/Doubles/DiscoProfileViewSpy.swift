//
//  DiscoProfileViewSpy.swift
//  PresentationTests
//
//  Created by Thiago Henrique on 11/12/23.
//

import Foundation
import Presentation

final class DiscoProfileViewSpy {
    private(set) var receivedMessages: [Message] = [Message]()
    
    enum Message: Equatable, CustomStringConvertible {
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
        
        var description: String {
            switch self {
                case .startLoading:
                    return "startLoading Called"
                case .hideLoading:
                    return "hideLoading Called"
                case .hideOverlays:
                    return "hideOverlays Called"
                case .showReferences(let references):
                    return "showReferences Called with data: \(references)"
                case .showProfile(let discoProfile):
                    return "showProfile Called with data: \(discoProfile)"
                case .updateReferences(let referenceList):
                    return "updateReferences Called with data: \(referenceList)"
                case .updateSections(let sections):
                    return "updateSections Called with data: \(sections)"
                case .addingReferencesError(let title, let description):
                    return "addingReferencesError Called with data: \(title), \(description)"
                case .addingSectionError(let title, let description):
                    return "addingSectionError Called with data: \(title), \(description)"
                case .loadingProfileError(let title, let description):
                    return "loadingProfileError Called with data: \(title), \(description)"
                case .addingRecordsError(let title, let description):
                    return "addingRecordsError Called with data: \(title), \(description)"
            }
        }
    }
    
    var hideOverlaysCompletion: (() -> Void)?
}

extension DiscoProfileViewSpy: DiscoProfileDisplayLogic {
    func addingRecordsError(_ title: String, description: String) {
        receivedMessages.append(.addingRecordsError(title, description))
    }
    
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
}
