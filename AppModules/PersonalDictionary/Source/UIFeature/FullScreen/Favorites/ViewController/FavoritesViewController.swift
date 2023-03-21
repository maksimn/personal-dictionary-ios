//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//


import UIKit

/// View controller экрана Избранного.
final class FavoritesViewController: UIViewController {

    private let favoriteWordListViewController: UIViewController
    private let theme: Theme

    /// - Parameters:
    ///  - headingText: текст заголовка экрана.
    ///  - favoriteWordListBuilder: билдер вложенной фичи "Список избранных слов".
    init(headingText: String,
         favoriteWordListBuilder: ViewControllerBuilder,
         theme: Theme) {
        favoriteWordListViewController = favoriteWordListBuilder.build()
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = headingText
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initViews() {
        view.backgroundColor = theme.backgroundColor
        layout(childViewController: favoriteWordListViewController)
    }
}
