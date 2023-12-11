//
//  DiscoProfileBusinessRule.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public protocol DiscoProfileBusinessRule {
    func searchNewReferences(keywords: String)
    func loadProfile(for disco: DiscoListViewEntity)
    func addNewReferences(for disco: DiscoListViewEntity, references: [AlbumReferenceViewEntity])
    func addNewSection(for disco: DiscoListViewEntity, section: SectionViewEntity)
}
