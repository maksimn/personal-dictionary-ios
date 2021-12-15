//
//  SearchTextInputBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

final class SearchTextInputBuilderImpl: SearchTextInputBuilder {

    private let dependencies = SearchTextInputDependencies()

    func build() -> SearchTextInputMVVM {
        SearchTextInputMVVMImpl(viewParams: dependencies.viewParams)
    }
}
