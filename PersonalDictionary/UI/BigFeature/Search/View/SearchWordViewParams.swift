//
//  SearchWordViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import Foundation

struct SearchWordViewStaticContent {
    let baseContent: WordListViewStaticContent
    let searchBarPlaceholderText: String
    let noWordsFoundText: String
    let searchByLabelText: String
    let sourceWordText: String
    let translationText: String
}

typealias SearchWordViewParams = ViewParams<SearchWordViewStaticContent, WordListViewStyles>
