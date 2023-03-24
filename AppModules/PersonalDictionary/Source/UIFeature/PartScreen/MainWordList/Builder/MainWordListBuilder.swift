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
        let wordListFetcher = WordListRepositoryImpl(
            langData: dependency.appConfig.langData,
            bundle: dependency.bundle
        )
        let viewModel = MainWordListViewModelImpl(
            wordListFetcher: wordListFetcher,
            logger: LoggerImpl(category: "PersonalDictionary.MainWordList")
        )
        let view = MainWordListViewController(
            viewModel: viewModel,
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, dependency: dependency)
        )

        return view
    }
}
