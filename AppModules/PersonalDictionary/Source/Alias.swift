//
//  Alias.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2022.
//

import RxCocoa

typealias BindableWordList = BehaviorRelay<WordListState>

typealias BindableSearchResult = BehaviorRelay<SearchResultData>

typealias WordListState = [Word]

typealias BindableDictionaryEntryState = BehaviorRelay<DictionaryEntryState>
