//
//  Alias.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2022.
//

import RxCocoa

typealias BindableString = BehaviorRelay<String>

typealias BindableSeachMode = BehaviorRelay<SearchMode>

typealias BindableWordList = BehaviorRelay<[Word]>

typealias BindableSearchResult = BehaviorRelay<SearchResultData>

typealias BindableNewWordState = BehaviorRelay<NewWordState>

typealias BindableLangPickerState = BehaviorRelay<LangPickerState?>
