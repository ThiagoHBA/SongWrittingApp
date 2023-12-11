//
//  DiscoProfileBusinessRule.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

protocol DiscoProfileBusinessRule {
    func searchNewReferences(keywords: String)
    func loadReferences(for disco: DiscoListViewEntity)
}
