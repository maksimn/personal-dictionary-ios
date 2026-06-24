//
//  Alias.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2022.
//

import Combine

typealias BindableWordList = CurrentValueSubject<WordListState, Never>

typealias BindableSearchResult = CurrentValueSubject<SearchResultData, Never>

typealias WordListState = [Word]

typealias BindableDictionaryEntryState = CurrentValueSubject<DictionaryEntryState, Never>
