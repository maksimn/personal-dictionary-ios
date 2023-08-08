//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UIKit

/// Реализация билдера фичи "Главный (основной) список слов" Личного словаря.
final class MainWordListBuilder: ViewControllerBuilder {

    private let dependency: RootDependency

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    /// Создать экран.
    /// - Returns:
    ///  - Экран "Главного (основного) списка слов".
    func build() -> UIViewController {
        let translationService = PonsTranslationService(
            secret: dependency.appConfig.ponsApiSecret,
            httpClient: LoggableHttpClient(logger: logger()),
            logger: logger()
        )

        let model = MainWordListModelImpl(
            wordListFetcher: WordListFetcherImpl(),
            сreateWordDbWorker: CreateWordDbWorkerImpl(),
            updateWordDbWorker: UpdateWordDbWorkerImpl(),
            translationService: translationService
        )
        let viewModel = MainWordListViewModelImpl(
            model: model,
            newWordStream: WordStreamImpl.instance,
            logger: logger()
        )
        let view = MainWordListViewController(
            viewModel: viewModel,
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, dependency: dependency)
        )

        return view
    }

    private func logger() -> Logger {
        LoggerImpl(category: "PersonalDictionary.MainWordList")
    }
}
