//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import CoreModule

enum DictionaryEntryState: Equatable {
    case initial
    case loading
    case loaded(Word)
    case error(WithError)
}

enum DictionaryEntryError: Error {
    case emptyDictionaryEntry(Word)
}

protocol DictionaryEntryViewModel {
    var state: BindableDictionaryEntryState { get }

    func load()

    func retryDictionaryEntryRequest()
}
