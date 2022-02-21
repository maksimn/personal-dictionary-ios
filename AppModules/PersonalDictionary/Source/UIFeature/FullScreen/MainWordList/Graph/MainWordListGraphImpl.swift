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
    private(set) var navigationController: UINavigationController?

    /// Инициализатор.
    /// - Parameters:
    ///  - viewParams: параметры представления Главного списка слов.
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    ///  - wordListFetcher: источник данных для получения списка слов из хранилища.
    ///  - newWordBuilder: билдер вложенной фичи "Добавление нового слова" в словарь.
    ///  - searchBuilder: билдер вложенной фичи "Поиск" по словам в словаре.
    ///  - coreRouter: базовый роутер для навигации к другому Продукту/Приложению в супераппе.
    init(viewParams: MainWordListViewParams,
         wordListBuilder: WordListBuilder,
         wordListFetcher: WordListFetcher,
         newWordBuilder: NewWordBuilder,
         searchBuilder: SearchBuilder,
         favoriteWordListBuilder: FavoriteWordListBuilder,
         coreRouter: CoreRouter?) {
        let navigationController = UINavigationController()
        let router = MainWordListRouterImpl(navigationController: navigationController,
                                            newWordBuilder: newWordBuilder)
        let navToSearchBuilder = NavToSearchBuilderImpl(navigationController: navigationController,
                                                        searchBuilder: searchBuilder)
        let headerBuilder = MainWordListHeaderBuilderImpl(navigationController: navigationController,
                                                          favoriteWordListBuilder: favoriteWordListBuilder)

        let controller = MainWordListViewController(viewParams: viewParams,
                                                    wordListMVVM: wordListBuilder.build(),
                                                    wordListFetcher: wordListFetcher,
                                                    router: router,
                                                    navToSearchBuilder: navToSearchBuilder,
                                                    headerBuilder: headerBuilder,
                                                    coreRouter: coreRouter)

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([controller], animated: false)
        self.navigationController = navigationController
    }
}
