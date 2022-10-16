//
//  MainNavigatorImpl.swift
//  SuperList
//
//  Created by Maksim Ivanov on 26.02.2022.
//

import UIKit

/// Реализация контейнера элементов навигации на Главном экране приложения.
final class MainNavigatorImpl: MainNavigator {

    private(set) weak var navigationController: UINavigationController?
    private let navToSearchBuilder: NavToSearchBuilder
    private let navToFavoriteWordListBuilder: NavToFavoritesBuilder
    private let navToNewWordBuilder: NavToNewWordBuilder
    private let navToTodoListAppBuilder: NavToTodoListAppBuilder

    /// Инициализатор,
    /// - Parameters:
    ///  - navigationController: корневой  navigation  сontroller приложения.
    ///  - navToSearchBuilder: билдер вложенной фичи "Элемент навигации на экран поиска".
    ///  - navToFavoritesBuilder: билдер вложенной фичи "Элемент навигации на экран списка избранных слов".
    ///  - navToNewWordBuilder: билдер вложенной фичи "Элемент навигации на экран добавления нового слова в словарь".
    ///  - navToTodoListAppBuilder: билдер вложенной фичи "Элемент навигации к приложению TodoList".
    init(navigationController: UINavigationController?,
         navToSearchBuilder: NavToSearchBuilder,
         navToFavoriteWordListBuilder: NavToFavoritesBuilder,
         navToNewWordBuilder: NavToNewWordBuilder,
         navToTodoListAppBuilder: NavToTodoListAppBuilder) {
        self.navigationController = navigationController
        self.navToSearchBuilder = navToSearchBuilder
        self.navToFavoriteWordListBuilder = navToFavoriteWordListBuilder
        self.navToNewWordBuilder = navToNewWordBuilder
        self.navToTodoListAppBuilder = navToTodoListAppBuilder
    }

    /// Добавить представления элементов навигации.
    func appendTo(rootView: UIView) {
        addNavToSearch()
        addNavToFavorites(rootView)
        addNavToNewWord(rootView)
        addNavToOtherApp(rootView)
    }

    private func addNavToSearch() {
        let navToSearchView = navToSearchBuilder.build()
        let navigationItem = navigationController?.viewControllers.first?.navigationItem

        navigationItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem?.titleView = navToSearchView
    }

    private func addNavToFavorites(_ rootView: UIView) {
        let navToFavoriteWordListView = navToFavoriteWordListBuilder.build()

        rootView.addSubview(navToFavoriteWordListView)
        navToFavoriteWordListView.snp.makeConstraints { make -> Void in
            make.top.equalTo(rootView.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(rootView.safeAreaLayoutGuide.snp.left)
            make.size.equalTo(CGSize(width: 60, height: 50))
        }
    }

    private func addNavToNewWord(_ rootView: UIView) {
        let navView = navToNewWordBuilder.build()

        rootView.addSubview(navView)
        navView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(rootView.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(rootView)
        }
    }

    private func addNavToOtherApp(_ rootView: UIView) {
        let navView = navToTodoListAppBuilder.build()

        rootView.addSubview(navView)
        navView.snp.makeConstraints { make -> Void in
            make.top.equalTo(rootView.safeAreaLayoutGuide.snp.top).offset(21)
            make.right.equalTo(rootView.snp.right).offset(-10)
        }
    }
}
