//
//  SearchWordViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.10.2021.
//

import UIKit

extension SearchWordViewController {

    func rearrangeViews() {
        rearrangeSearchBar()
        initWordsNotFoundLabelLabel()
        initSearchByLabel()
        initSearchBySegmentedControl()
    }

    private func rearrangeSearchBar() {
        searchBar.removeFromSuperview()

        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 72, height: 44)

        searchBar.isUserInteractionEnabled = true
        searchBar.frame = frame
        navigationItem.titleView = searchBar
        searchBar.placeholder = searchStaticContent.searchBarPlaceholderText
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }

    private func initWordsNotFoundLabelLabel() {
        wordsNotFoundLabel.textColor = .darkGray
        wordsNotFoundLabel.font = UIFont.systemFont(ofSize: 17)
        wordsNotFoundLabel.numberOfLines = 1
        wordsNotFoundLabel.textAlignment = .center
        wordsNotFoundLabel.text = searchStaticContent.noWordsFoundText
        wordsNotFoundLabel.isHidden = true
        view.addSubview(wordsNotFoundLabel)
        wordsNotFoundLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }

    private func initSearchByLabel() {
        searchByLabel.textColor = .darkGray
        searchByLabel.font = UIFont.systemFont(ofSize: 16)
        searchByLabel.numberOfLines = 1
        searchByLabel.textAlignment = .center
        searchByLabel.text = searchStaticContent.searchByLabelText
        view.addSubview(searchByLabel)
        searchByLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(26)
        }
    }

    private func initSearchBySegmentedControl() {
        searchBySegmentedControl = UISegmentedControl(items: [searchStaticContent.sourceWordText,
                                                              searchStaticContent.translationText])
        searchBySegmentedControl?.selectedSegmentIndex = 0
        searchBySegmentedControl?.addTarget(self, action: #selector(onSearchByValueChanged), for: .valueChanged)
        view.addSubview(searchBySegmentedControl ?? UIView())
        searchBySegmentedControl?.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10.5)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-22)
        }
    }

    @objc
    override var tableViewEdgeInsets: UIEdgeInsets {
        UIEdgeInsets(top: 54, left: 12, bottom: 0, right: 12)
    }
}
