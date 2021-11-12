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

    private let mainWordListViewParams = MainWordListViewParams(
        staticContent: MainWordListStaticContent(navToNewWordImage: UIImage(named: "icon-plus")!),
        styles: MainWordListStyles(
            navToNewWordButtonSize: CGSize(width: 44, height: 44),
            navToNewWordButtonBottomOffset: -26
        )
    )

    init(appConfigs: AppConfigs) {
        self.appConfigs = appConfigs
    }

    func build() -> MainWordListGraph {
        MainWordListGraphImpl(viewParams: mainWordListViewParams,
                              wordListBuilder: createWordListBuilder(),
                              wordListFetcher: buildWordListRepository(),
                              navigationController: navigationController,
                              newWordBuilder: createNewWordBuilder(),
                              searchBuilder: createSearchBuilder())
    }

    private func createSearchBuilder() -> SearchBuilder {
        SearchBuilderImpl(notificationCenter: NotificationCenter.default)
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
        let urlSessionCoreService = UrlSessionCoreService(sessionConfiguration: URLSessionConfiguration.default)

        return PonsTranslationService(apiData: ponsApiData,
                                      coreService: urlSessionCoreService,
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
