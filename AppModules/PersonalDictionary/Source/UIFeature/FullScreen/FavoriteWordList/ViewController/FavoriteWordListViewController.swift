//
//  FavoriteWordListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

struct FavoriteWordListViewParams {

    let heading: String
}

/// View controller экрана.
final class FavoriteWordListViewController: UIViewController {

    let params: FavoriteWordListViewParams

    let navToSearchBuilder: NavToSearchBuilder

    let headingLabel = UILabel()

    init(params: FavoriteWordListViewParams,
         navToSearchBuilder: NavToSearchBuilder) {
        self.params = params
        self.navToSearchBuilder = navToSearchBuilder
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
