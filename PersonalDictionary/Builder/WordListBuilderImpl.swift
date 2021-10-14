//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 14.10.2021.
//

import UIKit

final class WordListBuilderImpl: WordListBuilder {

    let ponsApiData = PonsApiData(url: "https://api.pons.com/v1/dictionary",
                                  secretHeaderKey: "X-Secret",
                                  secret: "")

    let logger = SimpleLogger()

    lazy var translationService = PonsTranslationService(apiData: ponsApiData,
                                                         coreService: UrlSessionCoreService(),
                                                         jsonCoder: JSONCoderImpl(),
                                                         logger: logger)

    lazy var langData: LangData = {
        let lang1 = Lang(id: Lang.Id(raw: 1), name: NSLocalizedString("English", comment: ""), shortName: "EN")
        let lang2 = Lang(id: Lang.Id(raw: 2), name: NSLocalizedString("Russian", comment: ""), shortName: "RU")
        let lang3 = Lang(id: Lang.Id(raw: 3), name: NSLocalizedString("French", comment: ""), shortName: "FR")
        let lang4 = Lang(id: Lang.Id(raw: 4), name: NSLocalizedString("Italian", comment: ""), shortName: "IT")

        let langData = LangData(allLangs: [lang1, lang2, lang3, lang4],
                                sourceLangKey: "io.github.maksimn.pd.sourceLang",
                                targetLangKey: "io.github.maksimn.pd.targetLang",
                                defaultSourceLang: lang1,
                                defaultTargetLang: lang2)

        return langData
    }()

    lazy var langRepository = {
        LangRepositoryImpl(userDefaults: UserDefaults.standard,
                           data: langData)
    }()

    lazy var wordListRepository: WordListRepository = {
        let coreWordListRepositoryArgs = CoreWordListRepositoryArgs(persistentContainerName: "StorageModel")

        return CoreWordListRepository(args: coreWordListRepositoryArgs,
                                      langRepository: langRepository,
                                      logger: logger)
    }()

    func buildMVVM() -> WordListMVVM {
        let navigationController = UINavigationController()
        let router = RouterImpl(navigationController: navigationController, builder: self)
        let wordListMVVM = WordListMVVMImpl(router: router,
                                            wordListRepository: wordListRepository,
                                            translationService: translationService,
                                            notificationCenter: NotificationCenter.default)
        let viewController = wordListMVVM.viewController ?? UIViewController()

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([viewController], animated: false)

        return wordListMVVM
    }

    func buildNewWordMVVM() -> NewWordMVVM {
        NewWordMVVMImpl(langRepository: langRepository,
                        notificationCenter: NotificationCenter.default)
    }

    func buildSearchWordMVVM() -> WordListMVVM {
        SearchWordMVVMImpl(wordListRepository: wordListRepository,
                           translationService: translationService,
                           notificationCenter: NotificationCenter.default)
    }
}
