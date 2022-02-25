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
    ///  - wordListBuilder: билдер вложенной фичи "Список слов".
    ///  - wordListFetcher: источник данных для получения списка слов из хранилища.
    ///  - newWordBuilder: билдер вложенной фичи "Добавление нового слова" в словарь.
    ///  - coreRouter: базовый роутер для навигации к другому Продукту/Приложению в супераппе.
    init(viewParams: MainWordListViewParams,
         navigationController: UINavigationController,
         mainNavigatorBuilder: MainNavigatorBuilder,
         wordListBuilder: WordListBuilder,
         wordListFetcher: WordListFetcher,
         coreRouter: CoreRouter?) {
        self.navigationController = navigationController

        let controller = MainWordListViewController(
            viewParams: viewParams,
            wordListMVVM: wordListBuilder.build(),
            wordListFetcher: wordListFetcher,
            coreRouter: coreRouter,
            mainNavigatorBuilder: mainNavigatorBuilder
        )

        navigationController.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController.setViewControllers([controller], animated: false)
    }
}
