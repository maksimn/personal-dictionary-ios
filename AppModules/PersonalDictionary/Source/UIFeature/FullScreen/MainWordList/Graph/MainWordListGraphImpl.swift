//
//  MainWordListGraphImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UIKit

/// Реализация графа фичи "Главный список слов".
final class MainWordListGraphImpl: MainWordListGraph {

    /// Корневой navigation controller фичи.
    let navigationController: UINavigationController

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления Главного списка слов.
    ///  - navigationController: корневой navigation controller приложения.
    ///  - navToSearchBuilder: билдер вложенной фичи "Навигация на экран Поиска".
    ///  - headerBuilder: билдер вложенной фичи  "Заголовок главного списка слов".
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    ///  - wordListFetcher: источник данных для получения списка слов из хранилища.
    ///  - newWordBuilder: билдер вложенной фичи "Добавление нового слова" в словарь.
    ///  - coreRouter: базовый роутер для навигации к другому Продукту/Приложению в супераппе.
    init(viewParams: MainWordListViewParams,
         navigationController: UINavigationController,
         navToSearchBuilder: NavToSearchBuilder,
         headerBuilder: NavToFavoriteWordListBuilder,
         wordListBuilder: WordListBuilder,
         wordListFetcher: WordListFetcher,
         newWordBuilder: NewWordBuilder,
         coreRouter: CoreRouter?) {
        self.navigationController = navigationController

        let router = MainWordListRouterImpl(
            navigationController: navigationController,
            newWordBuilder: newWordBuilder
        )

        let controller = MainWordListViewController(
            viewParams: viewParams,
            wordListMVVM: wordListBuilder.build(),
            wordListFetcher: wordListFetcher,
            router: router,
            navToSearchBuilder: navToSearchBuilder,
            headerBuilder: headerBuilder,
            coreRouter: coreRouter
        )

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([controller], animated: false)
    }
}
