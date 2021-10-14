//
//  SceneDelegate.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let wordListBuilder = WordListBuilderImpl()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let wordListMVVM = wordListBuilder.buildMVVM()
        guard let navigationController = wordListMVVM.navigationController else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
