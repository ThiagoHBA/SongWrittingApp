//
//  DiscoListBusinessRule.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public protocol DiscoListBusinessLogic {
    func loadDiscos()
    func createDisco(name: String, image: Data)
    func showProfile(of disco: DiscoListViewEntity)
}
