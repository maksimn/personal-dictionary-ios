//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import RealmSwift

struct DictionaryEntryModelImpl: DictionaryEntryModel {

    private let id: Word.Id

    init(id: Word.Id) {
        self.id = id
    }

    func load() throws -> Word {
        let realm = try Realm()
        let wordDAO = try realm.findWordBy(id: id)

        guard let word = Word(wordDAO) else {
            throw WordError.DAO2WordMappingError(wordDAO)
        }

        return word
    }
}
