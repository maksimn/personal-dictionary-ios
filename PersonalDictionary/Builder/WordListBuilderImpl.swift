//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 14.10.2021.
//

import UIKit

final class WordListBuilderImpl: WordListBuilder {

    func buildMVVM() -> WordListMVVM {
        let ponsApiData = PonsApiData(url: "https://api.pons.com/v1/dictionary",
                                      secretHeaderKey: "X-Secret",
                                      secret: "")
        let logger = buildLogger()
        let translationService = PonsTranslationService(apiData: ponsApiData,
                                                        coreService: UrlSessionCoreService(),
                                                        jsonCoder: JSONCoderImpl(),
                                                        logger: logger)

        let navigationController = UINavigationController()
        let wordListMVVM = WordListMVVMImpl(navigationController: navigationController,
                                            langRepository: buildLangRepository(),
                                            wordListRepository: buildWordListRepository(),
                                            translationService: translationService,
                                            notificationCenter: NotificationCenter.default)
        let viewController = wordListMVVM.viewController ?? UIViewController()

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([viewController], animated: false)

        return wordListMVVM
    }

    private func buildLangData() -> LangData {
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
    }

    private func buildLogger() -> Logger {
        SimpleLogger()
    }

    private func buildLangRepository() -> LangRepository {
        let langData = buildLangData()
        let langRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                                data: langData)

        return langRepository
    }

    private func buildWordListRepository() -> WordListRepository {
        let coreWordListRepositoryArgs = CoreWordListRepositoryArgs(persistentContainerName: "StorageModel")
        let logger = buildLogger()

        return CoreWordListRepository(args: coreWordListRepositoryArgs,
                                      langRepository: buildLangRepository(),
                                      logger: logger)
    }
}
