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

        let logger = SimpleLogger()
        let langRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                data: langResourceData)
        let translationService = PonsTranslationService(apiData: ponsApiData,
                                                        coreService: UrlSessionCoreService(),
                                                        jsonCoder: JSONCoderImpl(),
                                                        logger: logger)
        let wordListMVVM = WordListMVVMImpl(wordListRepository: CoreWordListRepository(langRepository: langRepository,
                                                                                       logger: logger),
                                            translationService: translationService,
                                            notificationCenter: NotificationCenter.default)
        guard let viewController = wordListMVVM.viewController else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
