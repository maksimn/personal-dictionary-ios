//
//  FavoriteWordListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// View controller экрана Избранного.
final class FavoritesViewController: UIViewController {

    private let favoriteWordListViewController: UIViewController

    private let theme: Theme

    /// - Parameters:
    ///  - headingText: текст заголовка экрана.
    ///  - navToSearchBuilder: билдер вложенной фичи "Навигация на экран Поиска".
    ///  - favoriteWordListBuilder: билдер вложенной фичи "Список избранных слов".
    init(headingText: String,
         navToSearchBuilder: SearchControllerBuilder,
         favoriteWordListBuilder: ViewControllerBuilder,
         theme: Theme) {
        favoriteWordListViewController = favoriteWordListBuilder.build()
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        initViews()
        navigationItem.title = headingText
        navigationItem.searchController = navToSearchBuilder.build()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initViews() {
        view.backgroundColor = theme.backgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        layout(wordListViewController: favoriteWordListViewController, topOffset: 46)
    }
}
