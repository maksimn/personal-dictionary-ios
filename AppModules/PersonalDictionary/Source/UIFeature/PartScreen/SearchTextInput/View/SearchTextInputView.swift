//
//  SearchTextInputView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import CoreModule
import UIKit

final class SearchTextInputView: UISearchController {

    private let sender: SearchTextSender
    private let logger: Logger

    init(sender: SearchTextSender, placeholder: String, logger: Logger) {
        self.sender = sender
        self.logger = logger
        super.init(searchResultsController: nil)
        searchBar.placeholder = placeholder
        obscuresBackgroundDuringPresentation = false
        searchBar.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.log(dismissedFeatureName: "PersonalDictionary.SearchTextInput")
    }

    private func onNext(_ searchText: String?) {
        guard let searchText = searchText else { return }

        logger.debug("User is entering search text: \"\(searchText)\"")
        sender.send(searchText)
    }
}

// MARK: - UISearchBarDelegate

extension SearchTextInputView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onNext(searchText)
    }
}
