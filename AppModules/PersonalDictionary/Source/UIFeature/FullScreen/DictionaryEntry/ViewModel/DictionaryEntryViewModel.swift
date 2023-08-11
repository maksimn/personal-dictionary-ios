//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

enum DictionaryEntryState {
    case initial
    case with(Word)
    case error(Error)
}

protocol DictionaryEntryViewModel {
    var state: BindableDictionaryEntryState { get }

    func load()
}
