//
//  FavoriteWordListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// View controller экрана Избранного.
final class FavoritesViewController: UIViewController {

    let heading: String

    let navToSearchView: UIView

    let favoriteWordListGraph: FavoriteWordListGraph

    let headingLabel = UILabel()

    /// - Parameters:
    ///  - heading: текст заголовка экрана.
    ///  - navToSearchBuilder: билдер вложенной фичи "Навигация на экран Поиска".
    ///  - favoriteWordListBuilder: билдер вложенной фичи "Список избранных слов".
    init(heading: String,
         navToSearchBuilder: NavToSearchBuilder,
         favoriteWordListBuilder: FavoriteWordListBuilder) {
        self.heading = heading
        navToSearchView = navToSearchBuilder.build()
        favoriteWordListGraph = favoriteWordListBuilder.build()
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteWordListGraph.model?.update()
    }
}
