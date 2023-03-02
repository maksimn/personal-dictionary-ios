//
//  Alias.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2022.
//

import RxCocoa

typealias BindableWordList = BehaviorRelay<[Word]>

typealias BindableSearchResult = BehaviorRelay<SearchResultData>

typealias BindableNewWordState = BehaviorRelay<NewWordState>

typealias BindableLangPickerState = BehaviorRelay<LangPickerState?>
