//
//  SceneDelegate.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let wordListBuilder = WordListBuilderImpl(globalSettings: pdGlobalSettings)
        let mainWordListContainer = wordListBuilder.buildMainWordListContainer()
        let navigationController = UINavigationController(rootViewController: mainWordListContainer)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
