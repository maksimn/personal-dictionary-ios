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

        let ponsApiData = PonsApiData(url: "https://api.pons.com/v1/dictionary",
                                      secretHeaderKey: "X-Secret",
                                      secret: "")

        let coreWordListRepositoryArgs = CoreWordListRepositoryArgs(persistentContainerName: "StorageModel")

        let lang1 = Lang(id: Lang.Id(raw: 1), name: NSLocalizedString("English", comment: ""), shortName: "EN")
        let lang2 = Lang(id: Lang.Id(raw: 2), name: NSLocalizedString("Russian", comment: ""), shortName: "RU")
        let lang3 = Lang(id: Lang.Id(raw: 3), name: NSLocalizedString("French", comment: ""), shortName: "FR")
        let lang4 = Lang(id: Lang.Id(raw: 4), name: NSLocalizedString("Italian", comment: ""), shortName: "IT")

        let langData = LangData(allLangs: [lang1, lang2, lang3, lang4],
                                sourceLangKey: "io.github.maksimn.pd.sourceLang",
                                targetLangKey: "io.github.maksimn.pd.targetLang",
                                defaultSourceLang: lang1,
                                defaultTargetLang: lang2)

        let logger = SimpleLogger()
        let langRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                data: langData)
        let translationService = PonsTranslationService(apiData: ponsApiData,
                                                        coreService: UrlSessionCoreService(),
                                                        jsonCoder: JSONCoderImpl(),
                                                        logger: logger)

        let navigationController = UINavigationController()

        let wordListMVVM = WordListMVVMImpl(navigationController: navigationController,
                                            langRepository: langRepository,
                                            wordListRepository: CoreWordListRepository(args: coreWordListRepositoryArgs,
                                                                                       langRepository: langRepository,
                                                                                       logger: logger),
                                            translationService: translationService,
                                            notificationCenter: NotificationCenter.default)
        guard let viewController = wordListMVVM.viewController else { return }

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([viewController], animated: false)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
