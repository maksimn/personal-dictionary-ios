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
    private let mainNavigator: MainNavigator
    private let searchController: UISearchController
    private let theme: Theme

    init(
        heading: String,
        mainSwitchBuilder: ViewControllerBuilder,
        mainNavigatorBuilder: MainNavigatorBuilder,
        searchTextInputBuilder: SearchControllerBuilder,
        theme: Theme
    ) {
        self.mainSwitchViewController = mainSwitchBuilder.build()
        self.mainNavigator = mainNavigatorBuilder.build()
        self.searchController = searchTextInputBuilder.build()
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
        mainNavigator.appendTo(rootView: view)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationItem.searchController = searchController
    }
}
