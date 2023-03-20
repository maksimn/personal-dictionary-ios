//
//  SearchTextInputView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import CoreModule
import UIKit

final class SearchControllerImpl: UISearchController, UISearchResultsUpdating, UISearchControllerDelegate {

    private let viewModel: SearchTextInputViewModel
    private let logger: SLogger

    init(viewModel: SearchTextInputViewModel, placeholder: String, logger: SLogger) {
        self.viewModel = viewModel
        self.logger = logger
        super.init(searchResultsController: nil)
        searchResultsUpdater = self
        obscuresBackgroundDuringPresentation = false
        searchBar.placeholder = placeholder
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        logger.log("User is entering search text: \"\(searchText)\"")

        viewModel.searchText.accept(searchText)
    }

    // MARK: - UISearchControllerDelegate

    func willDismissSearchController(_ searchController: UISearchController) {
        logger.log("User is dismissing search.")

        viewModel.mainScreenState.accept(.main)
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        logger.log("User is presenting search.")

        viewModel.mainScreenState.accept(.search)
    }
}