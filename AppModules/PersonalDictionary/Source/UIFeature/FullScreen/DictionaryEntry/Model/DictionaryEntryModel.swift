//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import RxSwift

protocol DictionaryEntryModel {

    func load() throws -> Word

    func getDictionaryEntry(for word: Word) -> Single<Word>
}
