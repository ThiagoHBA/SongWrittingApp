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
    func hideOverlays(completion: (() -> Void)?)
    func showDiscos(_ discos: [DiscoListViewEntity])
    func showNewDisco(_ disco: DiscoListViewEntity)
    func createDiscoError(_ title: String, _ description: String)
    func loadDiscoError(_ title: String, _ description: String)
}
