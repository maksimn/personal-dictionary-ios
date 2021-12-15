//
//  MainWordListDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import UIKit

final class MainWordListDependencies {

    let viewParams = MainWordListViewParams(
        staticContent: MainWordListStaticContent(navToNewWordImage: UIImage(named: "icon-plus")!),
        styles: MainWordListStyles(
            navToNewWordButtonSize: CGSize(width: 44, height: 44),
            navToNewWordButtonBottomOffset: -26
        )
    )

    private let appConfigs: AppConfigs

    private lazy var langRepository = buildLangRepository()

    init(appConfigs: AppConfigs) {
        self.appConfigs = appConfigs
    }

    func buildWordListRepository() -> WordListRepository {
        let coreWordListRepositoryArgs = CoreWordListRepositoryArgs(persistentContainerName: "StorageModel")

        return CoreWordListRepository(args: coreWordListRepositoryArgs,
                                      langRepository: langRepository,
                                      logger: buildLogger())
    }

    func createSearchBuilder() -> SearchBuilder {
        SearchBuilderImpl(appViewConfigs: appConfigs.appViewConfigs,
                          wordListFetcher: buildWordListRepository(),
                          wordListBuilder: createWordListBuilder())
    }

    func createNewWordBuilder() -> NewWordBuilder {
        NewWordBuilderImpl(appViewConfigs: appConfigs.appViewConfigs,
                           langRepository: langRepository)
    }

    func createWordListBuilder() -> WordListBuilder {
        WordListBuilderImpl(cudOperations: buildWordListRepository(),
                            translationService: buildTranslationService(),
                            appViewConfigs: appConfigs.appViewConfigs,
                            logger: buildLogger())
    }

    private func buildLangRepository() -> LangRepository {
        return LangRepositoryImpl(userDefaults: UserDefaults.standard,
                                  data: appConfigs.langData)
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
}
