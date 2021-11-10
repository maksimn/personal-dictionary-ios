//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

final class MainWordListBuilderImpl: MainWordListBuilder {

    func build() -> MainWordListGraph {
        MainWordListGraphImpl(wordListMVVM: buildWordListMVVM(),
                              wordListFetcher: buildWordListRepository(),
                              navigationController: navigationController,
                              mainWordListBuilder: self)
    }

    private lazy var langRepository = { buildLangRepository() }()

    private let globalSettings: PDGlobalSettings
    private let navigationController = UINavigationController()

    private lazy var wordListViewParams: WordListViewParams = {
        WordListViewParams(
            staticContent: WordListViewStaticContent(
                deleteAction: DeleteActionStaticContent(
                    image: UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
                )
            ),
            styles: WordListViewStyles(
                backgroundColor: globalSettings.appBackgroundColor,
                deleteAction: DeleteActionStyles(
                    backgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)
                )
            )
        )
    }()

    lazy var searchStaticContent = SearchWordViewStaticContent(
        baseContent: wordListViewParams.staticContent,
        searchBarPlaceholderText: NSLocalizedString("Enter a word for searching", comment: ""),
        noWordsFoundText: NSLocalizedString("No words found", comment: ""),
        searchByLabelText: NSLocalizedString("Search by:", comment: ""),
        sourceWordText: NSLocalizedString("source word", comment: ""),
        translationText: NSLocalizedString("translation", comment: "")
    )

    lazy var newWordViewParams: NewWordViewParams = {
        NewWordViewParams(
            staticContent: NewWordViewStaticContent(
                selectButtonTitle: NSLocalizedString("Select", comment: ""),
                arrowText: NSLocalizedString("⇋", comment: ""),
                okText: NSLocalizedString("OK", comment: ""),
                textFieldPlaceholder: NSLocalizedString("Enter a new word", comment: "")
            ),
            styles: NewWordViewStyles(backgroundColor: globalSettings.appBackgroundColor)
        )
    }()

    init(globalSettings: PDGlobalSettings) {
        self.globalSettings = globalSettings
    }

    func buildNewWordMVVM() -> NewWordMVVM {
        NewWordMVVMImpl(langRepository: langRepository,
                        notificationCenter: NotificationCenter.default,
                        viewParams: newWordViewParams,
                        langPickerBuilder: LangPickerBuilderImpl(allLangs: langRepository.allLangs,
                                                                 notificationCenter: NotificationCenter.default))
    }

    func buildSearchWordMVVM() -> WordListMVVM {
        SearchWordMVVMImpl(wordListRepository: buildWordListRepository(),
                           translationService: buildTranslationService(),
                           notificationCenter: NotificationCenter.default,
                           viewParams: SearchWordViewParams(staticContent: searchStaticContent,
                                                            styles: wordListViewParams.styles))
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

    private func buildWordListMVVM() -> WordListMVVM {
        WordListMVVMImpl(cudOperations: buildWordListRepository(),
                         translationService: buildTranslationService(),
                         notificationCenter: NotificationCenter.default,
                         viewParams: wordListViewParams)
    }
}
