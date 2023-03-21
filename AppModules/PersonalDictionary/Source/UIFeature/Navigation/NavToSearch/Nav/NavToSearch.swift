//
//  NavToSearchViewImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

/// Представление для навигации на экран Поиска.
final class NavToSearch: NSObject {

    private weak var navigationController: UINavigationController?
    private let navToSearchRouter: NavToSearchRouter
    private let logger: SLogger

    /// Инициализатор.
    /// - Parameters:
    ///  - router: роутер для навигации на экран Поиска.
    init(navigationController: UINavigationController, navToSearchRouter: NavToSearchRouter, logger: SLogger) {
        self.navigationController = navigationController
        self.navToSearchRouter = navToSearchRouter
        self.logger = logger
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var mainWordListViewController: UIViewController? {
        navigationController?.viewControllers.first?.children.first
    }
}

extension NavToSearch: UISearchControllerDelegate {

    func willDismissSearchController(_ searchController: UISearchController) {
        logger.log("User will dismiss search.")

        navToSearchRouter.dismissSearch()
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        logger.log("User did dismiss search.")

        mainWordListViewController?.view.isHidden = false
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        logger.log("User will present search.")

        mainWordListViewController?.view.isHidden = true
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        logger.log("User did present search.")

        navToSearchRouter.presentSearch()
    }
}
