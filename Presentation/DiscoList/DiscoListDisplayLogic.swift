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
    func showDiscos(_ discos: [Disco])
    func showNewDisco(_ disco: Disco)
    func showError(_ title: String, _ description: String)
}
