//
//  SearchBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import Foundation

final class SearchBuilderImpl: SearchBuilder {

    func build() -> SearchGraph {
        SearchGraphImpl(searchTextInputBuilder: SearchTextInputBuilderImpl())
    }
}
