//
//  DiscoListViewRouter.swift
//  UI
//
//  Created by Thiago Henrique on 10/12/23.
//

import Foundation
import Presentation
import UIKit

public final class DiscoListViewRouter: DiscoProfileRouter {
    let navigationController: UINavigationController
    let discoProfileViewController: (DiscoListViewEntity) -> DiscoProfileViewController
    
    public init(
        navigationController: UINavigationController,
        discoProfileViewController: @escaping (DiscoListViewEntity) -> DiscoProfileViewController
    ) {
        self.navigationController = navigationController
        self.discoProfileViewController = discoProfileViewController
    }

    public func showProfile(of disco: DiscoListViewEntity) {
        navigationController.pushViewController(discoProfileViewController(disco), animated: false)
    }
}
