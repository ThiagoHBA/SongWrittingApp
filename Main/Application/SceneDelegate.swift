//
//  SceneDelegate.swift
//  Main
//
//  Created by Thiago Henrique on 08/12/23.
//

import UIKit
import Presentation
import UI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let viewController = DiscoListFactory.make(navigationController: navigationController)
        navigationController.setViewControllers([viewController], animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
