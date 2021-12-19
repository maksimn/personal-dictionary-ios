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
                routingButtonTitle: routingButtonTitle,
                visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
            ),
            styles: MainWordListStyles(
                backgroundColor: appConfigs.appViewConfigs.appBackgroundColor,
                navToNewWordButtonSize: CGSize(width: 44, height: 44),
                navToNewWordButtonBottomOffset: -26
            )
        )
    }()

    private let appConfigs: AppConfigs

    let coreRouter: CoreRouter?
    private let routingButtonTitle: String

    private lazy var langRepository = buildLangRepository()

    init(appConfigs: AppConfigs,
         coreRouter: CoreRouter?,
         routingButtonTitle: String) {
        self.appConfigs = appConfigs
        self.coreRouter = coreRouter
        self.routingButtonTitle = routingButtonTitle
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
