//
//  SceneDelegate.swift
//  SuperList
//
//  Created by Maxim Ivanov on 19.12.2021.
//

import PersonalDictionary
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let appBuilder = PersonalDictionary.AppBuilderImpl()

    private(set) lazy var app = appBuilder.build()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = app.rootViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        let pushNotificationService = app.pushNotificationService

        pushNotificationService.schedule()
    }
}
