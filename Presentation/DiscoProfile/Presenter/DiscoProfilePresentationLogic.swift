//
//  DiscoProfilePresentationLogic.swift
//  Presentation
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation

public protocol DiscoProfilePresentationLogic {
    func presentLoading()
    func presentCreateSectionError(_ error: DiscoProfileError.CreateSectionError)
}
