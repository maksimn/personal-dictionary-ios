//
//  NavToSearchRouterImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

/// Реализация роутера для навигации на экран Поиска.
final class NavToSearchRouterImpl: NavToSearchRouter {

    private(set) weak var navigationController: UINavigationController?
    private let searchBuilder: ViewControllerBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - searchBuilder: билдер вложенной фичи "Поиск" по словам в словаре.
    init(navigationController: UINavigationController?,
         searchBuilder: ViewControllerBuilder) {
        self.navigationController = navigationController
        self.searchBuilder = searchBuilder
    }

    /// Перейти на экран поиска по словам в личном словаре.
    func navigateToSearch() {
        let searchWordVC = searchBuilder.build()

        navigationController?.pushViewController(searchWordVC, animated: true)
    }
}
