//
//  SceneDelegate.swift
//  PersonalDictionaryDev
//
//  Created by Maksim Ivanov on 25.03.2022.
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
        window?.rootViewController = app.navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        let pushNotificationService = app.pushNotificationService

        pushNotificationService.schedule()
    }
}
