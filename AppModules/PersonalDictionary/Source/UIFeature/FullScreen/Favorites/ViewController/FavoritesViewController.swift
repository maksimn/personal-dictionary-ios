//
//  FavoriteWordListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// View controller экрана Избранного.
final class FavoritesViewController: UIViewController {

    let params: FavoritesViewParams

    let navToSearchView: UIView

    let favoriteWordListGraph: FavoriteWordListGraph

    let headingLabel = UILabel()

    let centerLabel = UILabel()

    /// - Parameters:
    ///  - params: параметры представления списка избранных слов.
    ///  - navToSearchBuilder: билдер вложенной фичи "Навигация на экран Поиска".
    ///  - favoriteWordListBuilder: билдер вложенной фичи "Список избранных слов".
    init(params: FavoritesViewParams,
         navToSearchBuilder: NavToSearchBuilder,
         favoriteWordListBuilder: FavoriteWordListBuilder) {
        self.params = params
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
        update()
    }

    private func update() {
        guard let favoriteWordListModel = favoriteWordListGraph.model else {
            centerLabel.isHidden = false
            return
        }

        favoriteWordListModel.update()
        centerLabel.isHidden = !(favoriteWordListModel.isEmpty)
    }
}
