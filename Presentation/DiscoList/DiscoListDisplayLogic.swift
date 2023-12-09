//
//  DiscoListDisplayLogic.swift
//  Presentation
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation
import Domain

public protocol DiscoListDisplayLogic {
    func startLoading()
    func hideLoading()
    func showDiscos(_ discos: [DiscoListViewEntity])
    func showNewDisco(_ disco: DiscoListViewEntity)
    func showError(_ title: String, _ description: String)
}
