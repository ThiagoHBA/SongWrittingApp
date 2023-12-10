//
//  DiscoProfileFactory.swift
//  Main
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Presentation
import UI

struct DiscoProfileFactory {
    static func make(with data: DiscoListViewEntity) -> DiscoProfileViewController {
        let viewController = DiscoProfileViewController(disco: data)
        return viewController
    }
}
