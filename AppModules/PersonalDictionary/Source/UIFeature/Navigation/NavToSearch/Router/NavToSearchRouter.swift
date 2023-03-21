//
//  NavToSearchRouterImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

protocol NavToSearchRouter {

    func presentSearch()

    func dismissSearch()
}

/// Реализация роутера для навигации на экран Поиска.
final class NavToSearchRouterImpl: NavToSearchRouter {

    private weak var navigationController: UINavigationController?
    private weak var searchViewController: UIViewController?
    private let searchBuilder: ViewControllerBuilder

    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - searchBuilder: билдер вложенной фичи "Поиск" по словам в словаре.
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
