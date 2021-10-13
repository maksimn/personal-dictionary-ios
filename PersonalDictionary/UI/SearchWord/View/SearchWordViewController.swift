//
//  SearchWordViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.10.2021.
//

import UIKit

final class SearchWordViewController: WordListViewController, SearchWordView {

    let wordsNotFoundLabel = UILabel()
    let searchByLabel = UILabel()
    var searchBySegmentedControl: UISegmentedControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        rearrangeViews()
        viewModelOne?.prepareForSearching()
    }

    private var viewModelOne: SearchWordViewModel? {
        viewModel as? SearchWordViewModel
    }

    func setWordsNotFoundLabel(hidden: Bool) {
        wordsNotFoundLabel.isHidden = hidden
    }

    @objc
    func onSearchByValueChanged() {

    }
}

extension SearchWordViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            viewModelOne?.searchWord(contains: searchText)
        }
    }
}
