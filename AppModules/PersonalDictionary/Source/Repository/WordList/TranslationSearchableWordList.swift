//
//  WordListFetcher.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import CoreModule
import Foundation
import RealmSwift

protocol TranslationSearchableWordList {

    /// Найти слова, перевод которых содержит строку.
    /// - Parameters:
    ///  - string: строка для поиска.
    /// - Массив найденных слов.
    func findWords(whereTranslationContains string: String) -> [Word]
}

struct RealmTranslationSearchableWordList: TranslationSearchableWordList {

    func findWords(whereTranslationContains string: String) -> [Word] {
        let wordListFetcher = RealmWordListFetcher()
        var result: [Word] = []

        do {
            let words = try wordListFetcher.wordList()
            let realm = try Realm()

            for word in words {
                guard let dictionaryEntryDAO = realm.object(ofType: DictionaryEntryDAO.self,
                                                            forPrimaryKey: word.id.raw) else { continue }
                let dictionaryEntry = (
                    try? PonsDictionaryEntryDecoder().decode(dictionaryEntryDAO.entry, word: word)
                ) ?? []

                for entry in dictionaryEntry where (entry as NSString).localizedCaseInsensitiveContains(string) {
                    result.append(word)
                    break
                }
            }

            return result.sorted(by: { $0.createdAt > $1.createdAt })
        } catch {
            return []
        }
    }
}

struct TranslationSearchableWordListLog: TranslationSearchableWordList {

    let translationSearchableWordList: TranslationSearchableWordList
    let logger: CoreModule.Logger

    func findWords(whereTranslationContains string: String) -> [Word] {
        logger.log(
            "Searching words with translation containing \"\(string)\" in the personal dictionary...", level: .info)

        let result = translationSearchableWordList.findWords(whereTranslationContains: string)

        logger.log(
            "Words with translation containing \"\(string)\" found in the personal dictionary: \(result.count) words",
            level: .info
        )

        return result
    }
}
