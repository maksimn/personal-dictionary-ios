//
//  DictionaryEntryViewModel.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import RealmSwift
import RxSwift

struct DictionaryEntryModelImpl: DictionaryEntryModel {

    let id: Word.Id
    let dictionaryService: DictionaryService
    let updateWordDbWorker: UpdateWordDbWorker
    let updatedWordSender: UpdatedWordSender

    func load() throws -> Word {
        let realm = try Realm()
        let wordDAO = try realm.findWordBy(id: id)

        guard let word = Word(wordDAO) else {
            throw WordError.DAO2WordMappingError(wordDAO)
        }

        return word
    }

    func getDictionaryEntry(for word: Word) -> Single<Word> {
        dictionaryService.fetchDictionaryEntry(for: word)
            .flatMap { word in
                self.updateWordDbWorker.update(word: word)
            }
            .map { word in
                self.updatedWordSender.sendUpdatedWord(word)
                return word
            }
    }
}
