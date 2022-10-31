//
//  SearchViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 14.11.2021.
//

import UIKit

/// Лэйаут экрана поиска по словам в словаре.
extension SearchViewController {

    func initViews() {
        view.backgroundColor = Theme.data.backgroundColor
        initSearchTextInput()
        initSearchModePicker()
        initWordList()
        initCenterLabel()
    }

    private func initSearchTextInput() {
        searchTextInputMVVM.model?.listener = self
        navigationItem.titleView = searchTextInputMVVM.searchBar
    }

    private func initWordList() {
        let wordListViewController = wordListGraph.viewController
        let wordListParentView = UIView()

        view.addSubview(wordListParentView)
        wordListParentView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        let child = wordListViewController
        wordListParentView.addSubview(child.view)
        addChild(child)
        child.didMove(toParent: self)
        wordListViewController.view.snp.makeConstraints { make -> Void in
            make.edges.equalTo(wordListParentView)
        }
    }

    private func initCenterLabel() {
        centerLabel.textColor = Theme.data.secondaryTextColor
        centerLabel.font = Theme.data.normalFont
        centerLabel.numberOfLines = 1
        centerLabel.textAlignment = .center
        centerLabel.text = noResultFoundText
        centerLabel.isHidden = true
        view.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }

    private func initSearchModePicker() {
        searchModePickerMVVM.model?.listener = self

        let searchModePickerView = searchModePickerMVVM.uiview
        view.addSubview(searchModePickerView)
        searchModePickerView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(50)
        }
    }
}
