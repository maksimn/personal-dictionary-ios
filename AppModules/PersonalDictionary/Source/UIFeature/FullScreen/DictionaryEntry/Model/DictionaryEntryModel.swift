//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

protocol DictionaryEntryModel {

    func load() throws -> DictionaryEntryVO

    func getDictionaryEntry(for word: Word) async throws -> DictionaryEntryVO
}
