//
//  WordListFetcher.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import CoreModule

/// Протокол для поисковых запросов к хранилищу данных.
protocol SearchableWordList {

    /// Найти слова, содержащие строку.
    /// - Parameters:
    ///  - string: строка для поиска.
    /// - Массив найденных слов.
    func findWords(contain string: String) -> [Word]
}

struct RealmSearchableWordList: SearchableWordList {

    func findWords(contain string: String) -> [Word] {
        (try? realmWordListFilter { $0.filter("text contains[cd] \"\(string)\"") }) ?? []
    }
}

struct SearchableWordListLog: SearchableWordList {

    let searchableWordList: SearchableWordList
    let logger: Logger

    func findWords(contain string: String) -> [Word] {
        logger.log("Searching words containing \"\(string)\" in the personal dictionary...", level: .info)

        let result = searchableWordList.findWords(contain: string)

        logger.log(
            "Words containing \"\(string)\" found in the personal dictionary: \(result.count) words",
            level: .info
        )

        return result
    }
}
