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
            }
        }
    }
    
    var hideOverlaysCompletion: (() -> Void)?
}

extension DiscoProfileViewSpy: DiscoProfileDisplayLogic {
    func startLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func hideOverlays(completion: (() -> Void)?) {
        
    }
    
    func showReferences(_ references: [AlbumReferenceViewEntity]) {
        
    }
    
    func showProfile(_ profile: DiscoProfileViewEntity) {
        
    }
    
    func updateReferences(_ references: [AlbumReferenceViewEntity]) {
        
    }
    
    func updateSections(_ sections: [SectionViewEntity]) {
        
    }

    func addingReferencesError(_ title: String, description: String) {
        
    }
    
    func addingSectionError(_ title: String, description: String) {
        
    }
    
    func loadingProfileError(_ title: String, description: String) {
        
    }
}
