//
//  FavoriteWordListViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 14.11.2021.
//

import UIKit

/// Лэйаут экрана Избранного.
extension FavoritesViewController {

    func initViews() {
        view.backgroundColor = Theme.data.backgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.titleView = navToSearchView
        initHeadingLabel()
        addFavoriteWordListController()
    }

    private func initHeadingLabel() {
        headingLabel.textColor = Theme.data.textColor
        headingLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        headingLabel.numberOfLines = 1
        headingLabel.textAlignment = .left
        view.addSubview(headingLabel)
        headingLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(34.5)
        }
    }

    private func addFavoriteWordListController() {
        let wordListParentView = UIView()

        view.addSubview(wordListParentView)
        wordListParentView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(46)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        wordListParentView.addSubview(favoriteWordListViewController.view)
        addChild(favoriteWordListViewController)
        favoriteWordListViewController.didMove(toParent: self)
        favoriteWordListViewController.view.snp.makeConstraints { make -> Void in
            make.edges.equalTo(wordListParentView)
        }
    }
}
