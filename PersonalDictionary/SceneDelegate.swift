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

        let langRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                data: langResourceData)
        let wordListMVVM = WordListMVVMImpl(wordListRepository: CoreWordListRepository(langRepository: langRepository),
                                            notificationCenter: NotificationCenter.default)
        guard let viewController = wordListMVVM.viewController else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
