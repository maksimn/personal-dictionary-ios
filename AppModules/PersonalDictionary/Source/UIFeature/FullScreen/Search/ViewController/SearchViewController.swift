//
//  SearchViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// View controller экрана поиска по словам в словаре.
final class SearchViewController: UIViewController {

    private let searchTextInputView: UIView
    private let searchModePickerView: UIView
    private let searchWordListViewController: UIViewController

    init(searchTextInputView: UIView,
         searchModePickerView: UIView,
         searchWordListViewController: UIViewController) {
        self.searchTextInputView = searchTextInputView
        self.searchModePickerView = searchModePickerView
        self.searchWordListViewController = searchWordListViewController
        super.init(nibName: nil, bundle: nil)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View and Layout

    private func initViews() {
        view.backgroundColor = Theme.data.backgroundColor
        navigationItem.titleView = searchTextInputView
        initSearchModePicker()
        layout(wordListViewController: searchWordListViewController, topOffset: 50)
    }

    private func initSearchModePicker() {
        view.addSubview(searchModePickerView)
        searchModePickerView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(50)
        }
    }
}
