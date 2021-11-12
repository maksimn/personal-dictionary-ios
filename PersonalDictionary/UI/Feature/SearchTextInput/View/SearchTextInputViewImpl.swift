//
//  SearchTextInputViewImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

final class SearchTextInputViewImpl: UIView, SearchTextInputView, UISearchBarDelegate {

    var viewModel: SearchTextInputViewModel?

    let searchBar = UISearchBar()

    func initSearchBar() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 72, height: 44)

        searchBar.isUserInteractionEnabled = true
        searchBar.frame = frame
        searchBar.placeholder = NSLocalizedString("Enter a new word", comment: "")
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            print(searchText)
        }
    }
}
