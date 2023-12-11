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
    func showReferences(_ references: [AlbumReferenceViewEntity])
    func showProfile(_ profile: DiscoProfileViewEntity)
    func addingReferencesError(_ title: String, description: String)
    func loadingProfileError(_ title: String, description: String)
}

