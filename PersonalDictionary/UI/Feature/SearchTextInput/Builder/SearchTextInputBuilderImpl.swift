//
//  SearchTextInputBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

final class SearchTextInputBuilderImpl: SearchTextInputBuilder {

    func build() -> SearchTextInputMVVM {
        SearchTextInputMVVMImpl()
    }
}
