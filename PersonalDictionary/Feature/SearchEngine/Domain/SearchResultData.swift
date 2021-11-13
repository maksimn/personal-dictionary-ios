//
//  SearchResultData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

enum SearchState { case initial, fulfilled }

struct SearchResultData {
    let searchState: SearchState
    let foundWordList: [WordItem]
}
