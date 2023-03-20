//
//  MainWordListContainer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

/// View controller Главного экрана.
final class MainScreen: UIViewController {

    private let mainSwitchViewController: UIViewController
    private let searchController: UISearchController
    private let navToFavoritesBuilder: ViewBuilder
    private let navToTodoListBuilder: ViewBuilder
    private let theme: Theme

    init(
        heading: String,
        mainSwitchBuilder: ViewControllerBuilder,
        searchTextInputBuilder: SearchControllerBuilder,
        navToFavoritesBuilder: ViewBuilder,
        navToTodoListBuilder: ViewBuilder,
        theme: Theme
    ) {
        self.mainSwitchViewController = mainSwitchBuilder.build()
        self.searchController = searchTextInputBuilder.build()
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
        layout(childViewController: mainSwitchViewController)
        addNavToFavorites(view)
        addNavToTodoList(view)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationItem.searchController = searchController
    }

    // MARK: - Private

    private func addNavToFavorites(_ rootView: UIView) {
        let navView = navToFavoritesBuilder.build()

        navItem?.leftBarButtonItem = UIBarButtonItem(customView: navView)
    }

    private func addNavToTodoList(_ rootView: UIView) {
        let navView = navToTodoListBuilder.build()

        navItem?.rightBarButtonItem = UIBarButtonItem(customView: navView)
    }

    private var navItem: UINavigationItem? {
        navigationController?.viewControllers.first?.navigationItem
    }
}
