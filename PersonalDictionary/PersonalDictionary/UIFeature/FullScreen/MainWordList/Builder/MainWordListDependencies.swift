//
//  MainWordListDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import UIKit

final class MainWordListDependencies {

    private(set) lazy var viewParams = MainWordListViewParams(
        staticContent: MainWordListStaticContent(
            heading: NSLocalizedString("My dictionary", comment: ""),
            navToNewWordImage: UIImage(named: "icon-plus")!,
            superAppRoutingButtonTitle: superAppRoutingButtonTitle,
            visibleItemMaxCount: Int(ceil(UIScreen.main.bounds.height / WordItemCell.height))
        ),
        styles: MainWordListStyles(
            backgroundColor: appConfigs.appViewConfigs.appBackgroundColor,
            navToNewWordButtonSize: CGSize(width: 44, height: 44),
            navToNewWordButtonBottomOffset: -26
        )
    )

    private let appConfigs: AppConfigs

    let superAppRouter: SuperAppRouter?
    private let superAppRoutingButtonTitle: String

    private lazy var langRepository = buildLangRepository()

    init(appConfigs: AppConfigs,
         superAppRouter: SuperAppRouter?,
         superAppRoutingButtonTitle: String) {
        self.appConfigs = appConfigs
        self.superAppRouter = superAppRouter
        self.superAppRoutingButtonTitle = superAppRoutingButtonTitle
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
