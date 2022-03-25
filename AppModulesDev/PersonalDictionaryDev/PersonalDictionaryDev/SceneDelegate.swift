//
//  SceneDelegate.swift
//  PersonalDictionaryDev
//
//  Created by Maksim Ivanov on 25.03.2022.
//

import PersonalDictionary
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let personalDictionaryAppBuilder = PersonalDictionary.AppBuilderImpl()
        let personalDictionaryApp = personalDictionaryAppBuilder.build()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = personalDictionaryApp.navigationController
        window?.makeKeyAndVisible()
    }
}