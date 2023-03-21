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
    private let searchTextInput: UISearchController
    private let navToNewWordBuilder: NavToNewWordBuilder
    private let navToSearchBuilder: ViewBuilder
    private let navToFavoritesBuilder: ViewBuilder
    private let navToTodoListBuilder: ViewBuilder

    /// Инициализатор,
    /// - Parameters:
    ///  - navigationController: корневой  navigation  сontroller приложения.
    ///  - navToSearchBuilder: билдер вложенной фичи "Элемент навигации на экран поиска".
    ///  - navToFavoritesBuilder: билдер вложенной фичи "Элемент навигации на экран списка избранных слов".
    ///  - navToTodoListBuilder: билдер вложенной фичи "Элемент навигации к приложению TodoList".
    init(
        navigationController: UINavigationController?,
        searchTextInputBuilder: SearchControllerBuilder,
        navToNewWordBuilder: NavToNewWordBuilder,
        navToSearchBuilder: ViewBuilder,
        navToFavoritesBuilder: ViewBuilder,
        navToTodoListBuilder: ViewBuilder
    ) {
        self.navigationController = navigationController
        self.searchTextInput = searchTextInputBuilder.build()
        self.navToNewWordBuilder = navToNewWordBuilder
        self.navToSearchBuilder = navToSearchBuilder
        self.navToFavoritesBuilder = navToFavoritesBuilder
        self.navToTodoListBuilder = navToTodoListBuilder
    }

    /// Добавить представления элементов навигации.
    func appendTo(rootView: UIView) {
        addNavToNewWord(rootView)
        addNavToSearch(rootView)
        addNavToFavorites()
        addNavToTodoList()
    }

    func viewWillLayoutSubviews() {
        navigationItem?.searchController = searchTextInput
    }

    private func addNavToSearch(_ view: UIView) {
        let uiview = navToSearchBuilder.build()

        view.addSubview(uiview)
    }

    private func addNavToFavorites() {
        let navView = navToFavoritesBuilder.build()

        navigationItem?.leftBarButtonItem = UIBarButtonItem(customView: navView)
    }

    private func addNavToTodoList() {
        let navView = navToTodoListBuilder.build()

        navigationItem?.rightBarButtonItem = UIBarButtonItem(customView: navView)
    }

    private func addNavToNewWord(_ view: UIView) {
        let navToNewWordView = navToNewWordBuilder.build()

        view.addSubview(navToNewWordView)
        navToNewWordView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }
    }

    private var navigationItem: UINavigationItem? {
        navigationController?.viewControllers.first?.navigationItem
    }
}
