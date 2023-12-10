//
//  DiscoListPresentationLogic.swift
//  Presentation
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation

public protocol DiscoListPresentationLogic {
    func loadDiscos()
    func createDisco(name: String, image: Data)
}
