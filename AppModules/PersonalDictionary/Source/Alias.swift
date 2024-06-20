//
//  Alias.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2022.
//

import RxCocoa

typealias BindableString = BehaviorRelay<String>

typealias BindableSeachMode = BehaviorRelay<SearchMode>

typealias BindableWordList = BehaviorRelay<WordListState>

typealias BindableSearchResult = BehaviorRelay<SearchResultData>

typealias WordListState = [Word]

typealias BindableDictionaryEntryState = BehaviorRelay<DictionaryEntryState>
