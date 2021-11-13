//
//  SearchModeBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import Foundation

final class SearchModePickerBuilderImpl: SearchModePickerBuilder {

    private let initialSearchMode: SearchMode = .bySourceWord

    private let viewParams = SearchModePickerViewParams(
        staticContent: SearchModePickerStaticContent(
            searchByLabelText: NSLocalizedString("Search by:", comment: ""),
            sourceWordText: NSLocalizedString("source word", comment: ""),
            translationText: NSLocalizedString("translation", comment: "")
        ),
        styles: SearchModePickerStyles()
    )

    func build(_ listener: SearchModePickerListener) -> SearchModePickerMVVM {
        SearchModePickerMVVMImpl(searchMode: initialSearchMode,
                                 viewParams: viewParams,
                                 listener: listener)
    }
}
