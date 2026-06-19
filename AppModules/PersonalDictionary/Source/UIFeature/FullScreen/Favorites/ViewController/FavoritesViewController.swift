//
//  ViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule
import UIKit

/// View controller of the Favorites screen.
final class FavoritesViewController: UIViewController {

    private let favoriteWordListViewController: UIViewController
    private let theme: Theme

    /// - Parameters:
    ///  - title: screen title text.
    ///  - favoriteWordListBuilder: builder for the nested "Favorite Word List" feature.
    init(title: String,
         favoriteWordListBuilder: ViewControllerBuilder,
         theme: Theme) {
        favoriteWordListViewController = favoriteWordListBuilder.build()
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = title
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
