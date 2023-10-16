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
    let decoder: DictionaryEntryDecoder
    let updatedWordSender: UpdatedWordSender

    func load() throws -> DictionaryEntryVO {
        let realm = try Realm()
        let wordDAO = try realm.findWordBy(id: id)

        guard let word = Word(wordDAO) else {
            throw Fail.DAO2WordMappingError(wordDAO)
        }
        guard let dictionaryEntryDAO = realm.object(ofType: DictionaryEntryDAO.self, forPrimaryKey: id.raw) else {
            throw RealmWordError.dictionaryEntryNotFoundInRealm(id)
        }
        do {
            let dictionaryEntry = try decoder.decode(dictionaryEntryDAO.entry)

            return DictionaryEntryVO(word: word, entry: dictionaryEntry)
        } catch {
            return DictionaryEntryVO(word: word, entry: [])
        }
    }

    func getDictionaryEntry(for word: Word) -> Single<DictionaryEntryVO> {
        dictionaryService.fetchDictionaryEntry(for: word)
            .map { wordData in
                updatedWordSender.sendUpdatedWord(wordData.word)

                let dictionaryEntry = try decoder.decode(wordData.entry)

                return DictionaryEntryVO(word: wordData.word, entry: dictionaryEntry)
            }
    }

    enum Fail: Error {
        case DAO2WordMappingError(WordDAO)
    }
}
