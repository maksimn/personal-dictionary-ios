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
        let wordListFetcher = WordListRepositoryImpl(
            langData: dependency.appConfig.langData,
            bundle: dependency.bundle
        )
        let viewModel = MainWordListViewModelImpl(
            wordListFetcher: wordListFetcher,
            logger: SLoggerImp(category: "PersonalDictionary.MainWordList")
        )
        let view = MainWordListViewController(
            title: dependency.bundle.moduleLocalizedString("LS_MY_DICTIONARY"),
            viewModel: viewModel,
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, dependency: dependency),
            mainNavigatorBuilder: MainNavigatorBuilderImpl(dependency: dependency),
            searchTextInputBuilder: SearchTextInputBuilder(bundle: dependency.bundle),
            theme: Theme.data
        )

        return view
    }
}
