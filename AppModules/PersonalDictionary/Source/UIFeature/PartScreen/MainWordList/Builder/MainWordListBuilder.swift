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
        let wordListRepository = WordListRepositoryImpl(
            langData: dependency.appConfig.langData,
            bundle: dependency.bundle
        )
        let translationService = PonsTranslationService(
            secret: dependency.appConfig.ponsApiSecret,
            httpClient: HttpClientImpl(),
            logger: logger()
        )

        let model = MainWordListModelImpl(
            wordListRepository: wordListRepository,
            translationService: translationService
        )
        let presenter = MainWordListPresenterImpl(
            model: model,
            newWordStream: WordStreamImpl.instance,
            logger: logger()
        )
        let view = MainWordListViewController(
            presenter: presenter,
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, dependency: dependency)
        )

        presenter.view = view

        return view
    }

    private func logger() -> Logger {
        LoggerImpl(category: "PersonalDictionary.MainWordList")
    }
}
