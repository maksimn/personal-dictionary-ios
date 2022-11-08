//
//  FavoriteWordListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// View controller экрана Избранного.
final class FavoritesViewController: UIViewController {

    let heading: UILabel

    let navToSearchView: UIView

    let favoriteWordListViewController: UIViewController

    /// - Parameters:
    ///  - headingText: текст заголовка экрана.
    ///  - navToSearchBuilder: билдер вложенной фичи "Навигация на экран Поиска".
    ///  - favoriteWordListBuilder: билдер вложенной фичи "Список избранных слов".
    init(headingText: String,
         navToSearchBuilder: ViewBuilder,
         favoriteWordListBuilder: ViewControllerBuilder) {
        self.heading = Heading(headingText)
        navToSearchView = navToSearchBuilder.build()
        favoriteWordListViewController = favoriteWordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
