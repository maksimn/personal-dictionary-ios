//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import CoreModule

struct DictionaryEntryVO: Equatable {
    let word: Word
    let entry: DictionaryEntry
}

enum DictionaryEntryState: Equatable {
    case initial
    case loading
    case loaded(DictionaryEntryVO)
    case error(WithError)
}

protocol DictionaryEntryViewModel {
    var state: BindableDictionaryEntryState { get }

    func load()

    func retryDictionaryEntryRequest()
}
