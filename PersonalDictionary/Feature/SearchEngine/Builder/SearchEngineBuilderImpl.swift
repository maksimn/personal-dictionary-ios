//
//  SearchEngineBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

final class SearchEngineBuilderImpl: SearchEngineBuilder {

    func build() -> SearchEngine {
        SearchEngineImpl()
    }
}
