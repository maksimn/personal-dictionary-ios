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
        let category = "PersonalDictionary.MainWordList"
        let dictionaryService = PonsDictionaryService(
            secret: dependency.appConfig.ponsApiSecret,
            category: category
        )

        let model = MainWordListModelImpl(
            wordListFetcher: WordListFetcherImpl(),
            сreateWordDbWorker: CreateWordDbWorkerImpl(),
            updateWordDbWorker: UpdateWordDbWorkerImpl(),
            dictionaryService: dictionaryService
        )
        let viewModel = MainWordListViewModelImpl(
            model: model,
            newWordStream: WordStreamImpl.instance,
            logger: LoggerImpl(category: category)
        )
        let view = MainWordListViewController(
            viewModel: viewModel,
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, dependency: dependency)
        )

        return view
    }
}
