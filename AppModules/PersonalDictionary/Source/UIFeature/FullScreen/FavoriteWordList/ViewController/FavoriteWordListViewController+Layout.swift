//
//  FavoriteWordListViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 14.11.2021.
//

import UIKit

/// Лэйаут экрана списка избранных слов.
extension FavoriteWordListViewController {

    func initViews() {
        view.backgroundColor = Theme.data.backgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.titleView = navToSearchView
        initHeadingLabel()
        addWordListChildController()
        initCenterLabel()
    }

    private func initHeadingLabel() {
        headingLabel.textColor = Theme.data.textColor
        headingLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        headingLabel.numberOfLines = 1
        headingLabel.textAlignment = .left
        headingLabel.text = params.heading
        view.addSubview(headingLabel)
        headingLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(34.5)
        }
    }

    private func addWordListChildController() {
        let wordListViewController = wordListMVVM.viewController
        let wordListParentView = UIView()

        view.addSubview(wordListParentView)
        wordListParentView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(46)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        wordListParentView.addSubview(wordListViewController.view)
        addChild(wordListViewController)
        wordListViewController.didMove(toParent: self)
        wordListViewController.view.snp.makeConstraints { make -> Void in
            make.edges.equalTo(wordListParentView)
        }
    }

    private func initCenterLabel() {
        centerLabel.textColor = Theme.data.secondaryTextColor
        centerLabel.font = Theme.data.normalFont
        centerLabel.numberOfLines = 1
        centerLabel.textAlignment = .center
        centerLabel.text = params.noFavoriteWordsText
        view.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
}
