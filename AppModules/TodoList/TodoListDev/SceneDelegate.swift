//
//  SceneDelegate.swift
//  TodoListDev
//
//  Created by Maksim Ivanov on 26.07.2022.
//

import TodoList
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let mainBuilder = MainBuilderImp()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mainBuilder.build()
        window?.makeKeyAndVisible()
    }
}