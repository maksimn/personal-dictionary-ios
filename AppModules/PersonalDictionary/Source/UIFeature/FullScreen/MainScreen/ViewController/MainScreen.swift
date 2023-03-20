//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

/// View controller Главного экрана.
final class MainScreen: UIViewController {

    private let mainWordListViewController: UIViewController
    private let searchTextInput: UISearchController
    private let navToSearchBuilder: ViewBuilder
    private let navToFavoritesBuilder: ViewBuilder
    private let navToTodoListBuilder: ViewBuilder
    private let theme: Theme

    init(
        heading: String,
        mainWordListBuilder: ViewControllerBuilder,
        searchTextInputBuilder: SearchControllerBuilder,
        navToSearchBuilder: ViewBuilder,
        navToFavoritesBuilder: ViewBuilder,
        navToTodoListBuilder: ViewBuilder,
        theme: Theme
    ) {
        self.mainWordListViewController = mainWordListBuilder.build()
        self.searchTextInput = searchTextInputBuilder.build()
        self.navToSearchBuilder = navToSearchBuilder
        self.navToFavoritesBuilder = navToFavoritesBuilder
        self.navToTodoListBuilder = navToTodoListBuilder
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = heading
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) are not implemented.")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = UIView()

        view.backgroundColor = theme.backgroundColor
        layout(childViewController: mainWordListViewController)
        addNavToSearch()
        addNavToFavorites()
        addNavToTodoList()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationItem.searchController = searchTextInput
    }

    // MARK: - Private

    private func addNavToSearch() {
        let uiview = navToSearchBuilder.build()

        view.addSubview(uiview)
    }

    private func addNavToFavorites() {
        let navView = navToFavoritesBuilder.build()

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navView)
    }

    private func addNavToTodoList() {
        let navView = navToTodoListBuilder.build()

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navView)
    }
}
