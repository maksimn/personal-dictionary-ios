//
//  Alias.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2022.
//

import RxCocoa

typealias BindableMainScreenState = BehaviorRelay<MainScreenState>

typealias BindableString = BehaviorRelay<String>

typealias BindableSeachMode = BehaviorRelay<SearchMode>

typealias BindableWordList = BehaviorRelay<WordListState>

typealias BindableSearchResult = BehaviorRelay<SearchResultData>

typealias BindableNewWordState = BehaviorRelay<NewWordState>

typealias BindableLangPickerState = BehaviorRelay<LangPickerState?>

typealias WordListState = [Word]
