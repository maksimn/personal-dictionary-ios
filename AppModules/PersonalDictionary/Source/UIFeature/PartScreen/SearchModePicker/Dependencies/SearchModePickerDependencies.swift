//
//  SearchModePickerDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import Foundation

final class SearchModePickerDependencies {

    let initialSearchMode: SearchMode = .bySourceWord

    private(set) lazy var viewParams: SearchModePickerViewParams = {
        let bundle = Bundle(for: type(of: self))

        return SearchModePickerViewParams(
            searchByLabelText: bundle.moduleLocalizedString("Search by:"),
            sourceWordText: bundle.moduleLocalizedString("source word"),
            translationText: bundle.moduleLocalizedString("translation")
        )
    }()
}
