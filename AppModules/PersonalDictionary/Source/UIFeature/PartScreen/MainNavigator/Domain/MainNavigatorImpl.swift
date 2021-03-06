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
    private let navToFavoriteWordListBuilder: NavToFavoriteWordListBuilder
    private let navToNewWordBuilder: NavToNewWordBuilder
    private let navToTodoListAppBuilder: NavToTodoListAppBuilder

    /// Инициализатор,
    /// - Parameters:
    ///  - navigationController: корневой  navigation  сontroller приложения.
    ///  - navToSearchBuilder: билдер вложенной фичи "Элемент навигации на экран поиска".
    ///  - navToFavoriteWordListBuilder: билдер вложенной фичи "Элемент навигации на экран списка избранных слов".
    ///  - navToNewWordBuilder: билдер вложенной фичи "Элемент навигации на экран добавления нового слова в словарь".
    ///  - navToTodoListAppBuilder: билдер вложенной фичи "Элемент навигации к приложению TodoList".
    init(navigationController: UINavigationController?,
         navToSearchBuilder: NavToSearchBuilder,
         navToFavoriteWordListBuilder: NavToFavoriteWordListBuilder,
         navToNewWordBuilder: NavToNewWordBuilder,
         navToTodoListAppBuilder: NavToTodoListAppBuilder) {
        self.navigationController = navigationController
        self.navToSearchBuilder = navToSearchBuilder
        self.navToFavoriteWordListBuilder = navToFavoriteWordListBuilder
        self.navToNewWordBuilder = navToNewWordBuilder
        self.navToTodoListAppBuilder = navToTodoListAppBuilder
    }

    /// Добавить представления элементов навигации на экран.
    func addNavigationViews() {
        addNavToSearch()
        addNavToFavoriteWordList()
        addNavToNewWord()
        addNavToOtherApp()
    }

    private func addNavToSearch() {
        let navToSearchView = navToSearchBuilder.build()
        let navigationItem = navigationController?.viewControllers.first?.navigationItem

        navigationItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem?.titleView = navToSearchView
    }

    private func addNavToFavoriteWordList() {
        guard let view = view else { return }
        let navToFavoriteWordListView = navToFavoriteWordListBuilder.build()

        view.addSubview(navToFavoriteWordListView)
        navToFavoriteWordListView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.size.equalTo(CGSize(width: 60, height: 50))
        }
    }

    private func addNavToNewWord() {
        guard let view = view else { return }
        let navView = navToNewWordBuilder.build()

        view.addSubview(navView)
        navView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }
    }

    private func addNavToOtherApp() {
        guard let view = view else { return }
        let navView = navToTodoListAppBuilder.build()

        view.addSubview(navView)
        navView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(21)
            make.right.equalTo(view.snp.right).offset(-10)
        }
    }

    private var view: UIView? {
        navigationController?.viewControllers.first?.view
    }
}
