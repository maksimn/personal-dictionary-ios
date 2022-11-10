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
        layout(wordListViewController: wordListGraph.viewController, topOffset: 50)
        layoutCenterLabel()
    }

    private func initSearchTextInput() {
        searchTextInputGraph.model?.listener = self
        navigationItem.titleView = searchTextInputGraph.uiview
    }

    private func layoutCenterLabel() {
        centerLabel.isHidden = true
        view.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }

    private func initSearchModePicker() {
        searchModePickerGraph.model?.listener = self

        let searchModePickerView = searchModePickerGraph.uiview
        view.addSubview(searchModePickerView)
        searchModePickerView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(50)
        }
    }
}
