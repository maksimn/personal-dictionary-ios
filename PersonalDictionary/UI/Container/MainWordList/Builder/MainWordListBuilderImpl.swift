//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class MainWordListBuilderImpl: MainWordListBuilder {

    private lazy var langRepository = { buildLangRepository() }()

    private let globalSettings: PDGlobalSettings
    private let navigationController = UINavigationController()

    init(globalSettings: PDGlobalSettings) {
        self.globalSettings = globalSettings
    }

    func build() -> MainWordListGraph {
        MainWordListGraphImpl(wordListBuilder: createWordListBuilder(),
                              wordListFetcher: buildWordListRepository(),
                              navigationController: navigationController,
                              mainWordListBuilder: self)
    }

    func buildSearchWordMVVM() -> WordListMVVM {
        SearchWordMVVMImpl(globalSettings: globalSettings,
                           wordListRepository: buildWordListRepository(),
                           translationService: buildTranslationService(),
                           notificationCenter: NotificationCenter.default)
    }

    func createNewWordBuilder() -> NewWordBuilder {
        NewWordBuilderImpl(globalSettings: globalSettings,
                           langRepository: langRepository,
                           notificationCenter: NotificationCenter.default,
                           langPickerBuilder: LangPickerBuilderImpl(allLangs: langRepository.allLangs,
                                                                    notificationCenter: NotificationCenter.default))
    }

    // MARK: - private

    private func buildLogger() -> Logger {
        SimpleLogger(isLoggingEnabled: globalSettings.isLoggingEnabled)
    }

    private func buildTranslationService() -> TranslationService {
        let ponsApiData = PonsApiData(url: "https://api.pons.com/v1/dictionary",
                                      secretHeaderKey: "X-Secret",
                                      secret: globalSettings.ponsApiSecret)

        return PonsTranslationService(apiData: ponsApiData,
                                      coreService: UrlSessionCoreService(),
                                      jsonCoder: JSONCoderImpl(),
                                      logger: buildLogger())
    }

    private func buildWordListRepository() -> WordListRepository {
        let coreWordListRepositoryArgs = CoreWordListRepositoryArgs(persistentContainerName: "StorageModel")

        return CoreWordListRepository(args: coreWordListRepositoryArgs,
                                      langRepository: langRepository,
                                      logger: buildLogger())
    }

    private func buildLangRepository() -> LangRepository {
        return LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                  data: globalSettings.langData)
    }

    private func createWordListBuilder() -> WordListBuilder {
        WordListBuilderImpl(cudOperations: buildWordListRepository(),
                            translationService: buildTranslationService(),
                            notificationCenter: NotificationCenter.default,
                            globalSettings: globalSettings)
    }
}
