//
//  MainWordListDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import CoreModule
import UIKit

final class MainWordListDependencies {

    private(set) lazy var viewParams: MainWordListViewParams = {
        let bundle = Bundle(for: type(of: self))

        return MainWordListViewParams(
            staticContent: MainWordListStaticContent(
                heading: bundle.moduleLocalizedString("My dictionary"),
                navToNewWordImage: UIImage(named: "icon-plus", in: bundle, compatibleWith: nil)!,
                routingButtonTitle: appConfigs.outer.routingButtonTitle,
                visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
            ),
            styles: MainWordListStyles(
                backgroundColor: appConfigs.appViewConfigs.appBackgroundColor,
                navToNewWordButtonSize: CGSize(width: 44, height: 44),
                navToNewWordButtonBottomOffset: -26
            )
        )
    }()

    var coreRouter: CoreRouter? {
        appConfigs.outer.coreRouter
    }

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
        SimpleLogger(isLoggingEnabled: appConfigs.outer.coreModuleParams.isLoggingEnabled)
    }

    private func buildTranslationService() -> TranslationService {
        let ponsApiData = PonsApiData(url: "https://api.pons.com/v1/dictionary",
                                      secretHeaderKey: "X-Secret",
                                      secret: appConfigs.ponsApiSecret)
        let urlSessionCoreService = UrlSessionCoreService(
            sessionConfiguration: appConfigs.outer.coreModuleParams.urlSessionConfiguration
        )

        return PonsTranslationService(apiData: ponsApiData,
                                      coreService: urlSessionCoreService,
                                      jsonCoder: JSONCoderImpl(),
                                      logger: buildLogger())
    }
}
