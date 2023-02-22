//
//  FavoriteWordListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// View controller экрана Избранного.
final class FavoritesViewController: UIViewController {

    private let heading: UILabel

    private let navToSearchView: UIView

    private let favoriteWordListViewController: UIViewController

    private let theme: Theme

    /// - Parameters:
    ///  - headingText: текст заголовка экрана.
    ///  - navToSearchBuilder: билдер вложенной фичи "Навигация на экран Поиска".
    ///  - favoriteWordListBuilder: билдер вложенной фичи "Список избранных слов".
    init(headingText: String,
         navToSearchBuilder: ViewBuilder,
         favoriteWordListBuilder: ViewControllerBuilder,
         theme: Theme) {
        self.heading = Heading(headingText, theme)
        navToSearchView = navToSearchBuilder.build()
        favoriteWordListViewController = favoriteWordListBuilder.build()
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initViews() {
        view.backgroundColor = theme.backgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.titleView = navToSearchView
        layoutHeading()
        layout(wordListViewController: favoriteWordListViewController, topOffset: 46)
    }

    private func layoutHeading() {
        view.addSubview(heading)
        heading.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(34.5)
        }
    }
}
