//
//  SceneDelegate.swift
//  SuperList
//
//  Created by Maxim Ivanov on 19.12.2021.
//

import CoreModule
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let view = UIViewController()

        let logger = LoggerImpl(category: "xxx")

        logger.log("I warn you", level: .warn)

        view.view.backgroundColor = .red

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = view
        window?.makeKeyAndVisible()
    }
}
