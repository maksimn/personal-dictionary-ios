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
        guard let realm = try? Realm() else { return [] }

        return realm.objects(WordTranslationIndexDAO.self)
            .filter("ANY translations contains[cd] \"\(string)\"")
            .map { $0.wordId }
            .removingDuplicates()
            .compactMap { wordId in
                guard let wordDAO = try? realm.findWordBy(id: .init(raw: wordId)) else { return nil }

                return Word(wordDAO)
            }
            .sorted(by: { $0.createdAt > $1.createdAt })
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
