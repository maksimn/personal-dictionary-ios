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

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Создать экран.
    /// - Returns:
    ///  - Экран "Главного (основного) списка слов".
    func build() -> UIViewController {
        let featureName = "PersonalDictionary.MainWordList"
        let dictionaryServiceFactory = DictionaryServiceFactory(
            secret: dependency.appConfig.ponsApiSecret,
            featureName: featureName,
            bundle: dependency.bundle,
            isErrorSendable: true
        )

        let model = MainWordListModelImpl(
            wordListFetcher: WordListFetcherFactory(featureName: featureName).create(),
            сreateWordDbWorker: CreateWordDbWorkerFactory(featureName: featureName).create(),
            dictionaryService: dictionaryServiceFactory.create()
        )
        let viewModel = MainWordListViewModelImpl(
            model: model,
            newWordStream: WordStreamImpl.instance,
            logger: LoggerImpl(category: featureName)
        )
        let view = MainWordListViewController(
            viewModel: viewModel,
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, dependency: dependency)
        )

        return view
    }
}
