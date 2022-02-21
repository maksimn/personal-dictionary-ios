//
//  MainWordListHeaderBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Реализация билдера фичи "Заголовок Главного списка слов".
final class MainWordListHeaderBuilderImpl: MainWordListHeaderBuilder {

    private let navigationController: UINavigationController
    private let favoriteWordListBuilder: FavoriteWordListBuilder

    /// Инициализатор.
    /// - Parameters:
    ///  - navigationController: корневой navigation controller приложения.
    ///  - favoriteWordListBuilder: билдер вложенной фичи.
    init(navigationController: UINavigationController,
         favoriteWordListBuilder: FavoriteWordListBuilder) {
        self.navigationController = navigationController
        self.favoriteWordListBuilder = favoriteWordListBuilder
    }

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView {
        let router = RoutingToFavoriteWordListImpl(navigationController: navigationController,
                                                   favoriteWordListBuilder: favoriteWordListBuilder)
        let bundle = Bundle(for: type(of: self))
        let viewParams = MainWordListHeaderViewParams(
            heading: bundle.moduleLocalizedString("My dictionary"),
            routingButtonTitle: "☆"
        )
        let view = MainWordListHeaderView(params: viewParams,
                                          router: router)

        return view
    }
}
