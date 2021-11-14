//
//  SearchViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 14.11.2021.
//

import UIKit

extension SearchViewController {

    func addFeature(_ searchTextInputBuilder: SearchTextInputBuilder) {
        searchTextInputMVVM = searchTextInputBuilder.build(self)
        navigationItem.titleView = searchTextInputMVVM?.uiview
    }

    func addWordListViewController() {
        guard let wordListViewController = wordListMVVM.viewController else { return }
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

    func addSearchResultTextLabel(_ params: TextLabelParams) {
        searchResultTextLabel = TextLabel(params: params)
        searchResultTextLabel?.isHidden = true
        view.addSubview(searchResultTextLabel ?? UIView())
        searchResultTextLabel?.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }

    func addFeature(_ searchModePickerBuilder: SearchModePickerBuilder) {
        searchModePickerMVVM = searchModePickerBuilder.build(self)

        guard let searchModePickerView = searchModePickerMVVM?.uiview else { return }
        view.addSubview(searchModePickerView)
        searchModePickerView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(50)
        }
    }
}
