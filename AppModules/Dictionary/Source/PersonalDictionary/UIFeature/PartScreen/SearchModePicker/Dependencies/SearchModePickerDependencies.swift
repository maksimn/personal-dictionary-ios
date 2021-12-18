//
//  SearchModePickerDependencies.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 04.12.2021.
//

import Foundation

final class SearchModePickerDependencies {

    let initialSearchMode: SearchMode = .bySourceWord

    let viewParams = SearchModePickerViewParams(
        staticContent: SearchModePickerStaticContent(
            searchByLabelText: NSLocalizedString("Search by:", comment: ""),
            sourceWordText: NSLocalizedString("source word", comment: ""),
            translationText: NSLocalizedString("translation", comment: "")
        ),
        styles: SearchModePickerStyles()
    )
}
