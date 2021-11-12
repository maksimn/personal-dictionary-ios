//
//  SearchViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

extension SearchViewController {

    func initSearchBar() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 72, height: 44)

        searchBar.isUserInteractionEnabled = true
        searchBar.frame = frame
        navigationItem.titleView = searchBar
        searchBar.placeholder = NSLocalizedString("Enter a new word", comment: "")
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }
}
