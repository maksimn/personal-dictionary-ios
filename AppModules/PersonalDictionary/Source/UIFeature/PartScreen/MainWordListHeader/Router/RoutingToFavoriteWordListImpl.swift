//
//  RoutingToFavoriteWordListImpl.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

/// Реализация роутера для навигации на экран списка избранных слов.
final class RoutingToFavoriteWordListImpl: RoutingToFavoriteWordList {

    private let navigationController: UINavigationController
    private let favoriteWordListBuilder: FavoriteWordListBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - favoriteWordListBuilder: билдер вложенной фичи "Списк избранных слов".
    init(navigationController: UINavigationController,
         favoriteWordListBuilder: FavoriteWordListBuilder) {
        self.navigationController = navigationController
        self.favoriteWordListBuilder = favoriteWordListBuilder
    }

    /// Перейти на экран списка избранных слов личногр словаря.
    func navigateToFavoriteWordList() {
        let favoriteWordListViewController = favoriteWordListBuilder.build()

        navigationController.pushViewController(favoriteWordListViewController, animated: true)
    }
}
