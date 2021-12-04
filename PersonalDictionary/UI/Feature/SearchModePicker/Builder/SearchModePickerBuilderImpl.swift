//
//  SearchModeBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

final class SearchModePickerBuilderImpl: SearchModePickerBuilder {

    private let dependencies = SearchModePickerDependencies()

    func build() -> SearchModePickerMVVM {
        SearchModePickerMVVMImpl(searchMode: dependencies.initialSearchMode,
                                 viewParams: dependencies.viewParams)
    }
}
