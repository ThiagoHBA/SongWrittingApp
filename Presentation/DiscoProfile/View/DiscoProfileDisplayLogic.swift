//
//  DiscoProfileDisplayLogic.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public protocol DiscoProfileDisplayLogic {
    func startLoading()
    func hideLoading()
    func hideOverlays(completion: (() -> Void)?)
    func showReferences(_ references: [AlbumReferenceViewEntity])
    func showProfile(_ profile: DiscoProfileViewEntity)
    func updateReferences(_ references: [AlbumReferenceViewEntity])
    func updateSections(_ sections: [SectionViewEntity])
    func addingReferencesError(_ title: String, description: String)
    func addingSectionError(_ title: String, description: String)
    func loadingProfileError(_ title: String, description: String)
    func addingRecordsError(_ title: String, description: String)
}

