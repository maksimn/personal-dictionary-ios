//
//  NavToSearchRouterImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import CoreModule
import UIKit

protocol NavToSearchRouter {

    func presentSearch()

    func dismissSearch()
}

/// Implementation of the router for navigation to the Search screen.
final class NavToSearchRouterImpl: NavToSearchRouter {

    private weak var navigationController: UINavigationController?
    private weak var searchViewController: UIViewController?
    private let searchBuilder: ViewControllerBuilder

    /// - Parameters:
    ///  - navigationController: root navigation controller of the application.
    ///  - searchBuilder: builder of the nested "Search" feature for dictionary words.
    init(navigationController: UINavigationController?,
         searchBuilder: ViewControllerBuilder) {
        self.navigationController = navigationController
        self.searchBuilder = searchBuilder
    }

    func presentSearch() {
        guard searchViewController == nil else { return }
        let searchViewController = searchBuilder.build()

        navigationController?.topViewController?.layout(childViewController: searchViewController)

        self.searchViewController = searchViewController
    }

    func dismissSearch() {
        self.searchViewController?.removeFromParentViewController()
        self.searchViewController = nil
    }
}
