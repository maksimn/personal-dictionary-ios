//
//  SceneDelegate.swift
//  SuperList
//
//  Created by Maxim Ivanov on 19.12.2021.
//

import TodoList
import CoreModule
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let todoListBuilder = TodoList.MainBuilderImp()

        let logger = LoggerImpl(category: "xxx")

        logger.log("Some message", level: .warn)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = todoListBuilder.build()
        window?.makeKeyAndVisible()
    }
}
