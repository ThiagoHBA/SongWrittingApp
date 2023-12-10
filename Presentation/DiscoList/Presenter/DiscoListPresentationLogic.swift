//
//  DiscoListPresentationLogic.swift
//  Presentation
//
//  Created by Thiago Henrique on 09/12/23.
//

import Foundation
import Domain

public protocol DiscoListPresentationLogic {
    func presentLoading()
    func presentCreateDiscoError(_ error: DiscoListError.CreateDiscoError)
}
