//
//  MainNavigatorImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import UIKit

/// Реализация контейнера элементов навигации на Главном экране приложения.
final class MainNavigatorImpl: MainNavigator {

    private weak var navigationController: UINavigationController?
    private let navToFavoritesBuilder: ViewBuilder
    private let navToNewWordBuilder: ViewBuilder
    private let navToTodoListBuilder: ViewBuilder

    /// - Parameters:
    ///  - navigationController: корневой  navigation  сontroller приложения.
    ///  - navToFavoritesBuilder: билдер вложенной фичи "Элемент навигации на экран списка избранных слов".
    ///  - navToNewWordBuilder: билдер вложенной фичи "Элемент навигации на экран добавления нового слова в словарь".
    ///  - navToTodoListBuilder: билдер вложенной фичи "Элемент навигации к приложению TodoList".
    init(
        navigationController: UINavigationController?,
        navToFavoritesBuilder: ViewBuilder,
        navToNewWordBuilder: ViewBuilder,
        navToTodoListBuilder: ViewBuilder
    ) {
        self.navigationController = navigationController
        self.navToFavoritesBuilder = navToFavoritesBuilder
        self.navToNewWordBuilder = navToNewWordBuilder
        self.navToTodoListBuilder = navToTodoListBuilder
    }

    /// Добавить представления элементов навигации.
    func appendTo(rootView: UIView) {
        addNavToFavorites(rootView)
        addNavToNewWord(rootView)
        addNavToTodoList(rootView)
    }

    private func addNavToFavorites(_ rootView: UIView) {
        let navToFavoriteWordListView = navToFavoritesBuilder.build()

        navItem?.leftBarButtonItem = UIBarButtonItem(customView: navToFavoriteWordListView)
    }

    private func addNavToNewWord(_ rootView: UIView) {
        let navView = navToNewWordBuilder.build()

        rootView.addSubview(navView)
        navView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(rootView.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(rootView)
        }
        navView.layer.zPosition = 100
    }

    private func addNavToTodoList(_ rootView: UIView) {
        let navView = navToTodoListBuilder.build()

        navItem?.rightBarButtonItem = UIBarButtonItem(customView: navView)
    }

    private var navItem: UINavigationItem? {
        navigationController?.viewControllers.first?.navigationItem
    }
}
