//
//  MainWordListContainer+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 08.11.2021.
//

import UIKit

/// Лэйаут экрана Главного списка слов.
extension MainWordListViewController {

    func initViews() {
        view.backgroundColor = Theme.data.backgroundColor
        addWordListChildController()
        initHeadingLabel()
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

    private func initHeadingLabel() {
        headingLabel.textColor = Theme.data.textColor
        headingLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        headingLabel.numberOfLines = 1
        headingLabel.textAlignment = .left
        headingLabel.text = params.heading
        view.addSubview(headingLabel)
        headingLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(14)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(54.5)
        }
    }
}
