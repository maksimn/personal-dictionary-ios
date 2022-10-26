//
//  FavoriteWordListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// View controller экрана Избранного.
final class FavoritesViewController: UIViewController {

    let headingLabel = UILabel()

    let navToSearchView: UIView

    let favoriteWordListViewController: UIViewController

    /// - Parameters:
    ///  - heading: текст заголовка экрана.
    ///  - navToSearchBuilder: билдер вложенной фичи "Навигация на экран Поиска".
    ///  - favoriteWordListBuilder: билдер вложенной фичи "Список избранных слов".
    init(heading: String,
         navToSearchBuilder: ViewBuilder,
         favoriteWordListBuilder: ViewControllerBuilder) {
        headingLabel.text = heading
        navToSearchView = navToSearchBuilder.build()
        favoriteWordListViewController = favoriteWordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
