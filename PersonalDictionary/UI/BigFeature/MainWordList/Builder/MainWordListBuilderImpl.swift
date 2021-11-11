//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class MainWordListBuilderImpl: MainWordListBuilder {

    private lazy var langRepository = { buildLangRepository() }()

    private let appConfigs: AppConfigs
    private let navigationController = UINavigationController()

    init(appConfigs: AppConfigs) {
        self.appConfigs = appConfigs
    }

    func build() -> MainWordListGraph {
        MainWordListGraphImpl(wordListBuilder: createWordListBuilder(),
                              wordListFetcher: buildWordListRepository(),
                              navigationController: navigationController,
                              newWordBuilder: createNewWordBuilder(),
                              searchBuilder: createSearchBuilder())
    }

    private func createSearchBuilder() -> SearchBuilder {
        SearchBuilderImpl(appViewConfigs: appConfigs.appViewConfigs,
                          wordListRepository: buildWordListRepository(),
                          translationService: buildTranslationService(),
                          notificationCenter: NotificationCenter.default)
    }

    private func createNewWordBuilder() -> NewWordBuilder {
        NewWordBuilderImpl(appViewConfigs: appConfigs.appViewConfigs,
                           langRepository: langRepository,
                           notificationCenter: NotificationCenter.default,
                           langPickerBuilder: LangPickerBuilderImpl(allLangs: langRepository.allLangs,
                                                                    notificationCenter: NotificationCenter.default,
                                                                    appViewConfigs: appConfigs.appViewConfigs))
    }

    private func buildLogger() -> Logger {
        SimpleLogger(isLoggingEnabled: appConfigs.isLoggingEnabled)
    }

    private func buildTranslationService() -> TranslationService {
        let ponsApiData = PonsApiData(url: "https://api.pons.com/v1/dictionary",
                                      secretHeaderKey: "X-Secret",
                                      secret: appConfigs.ponsApiSecret)

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
                                  data: appConfigs.langData)
    }

    private func createWordListBuilder() -> WordListBuilder {
        WordListBuilderImpl(cudOperations: buildWordListRepository(),
                            translationService: buildTranslationService(),
                            notificationCenter: NotificationCenter.default,
                            appViewConfigs: appConfigs.appViewConfigs)
    }
}
