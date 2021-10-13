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
        initMessageLabel()
    }

    private func rearrangeSearchBar() {
        searchBar.removeFromSuperview()

        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 72, height: 44)

        searchBar.isUserInteractionEnabled = true
        searchBar.frame = frame
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Enter a word for searching"
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }

    private func initMessageLabel() {
        messageLabel.textColor = .darkGray
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .center
        messageLabel.text = "No words found"
        messageLabel.isHidden = true
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }

    @objc
    override var tableViewEdgeInsets: UIEdgeInsets {
        UIEdgeInsets(top: 54, left: 12, bottom: 0, right: 12)
    }
}
