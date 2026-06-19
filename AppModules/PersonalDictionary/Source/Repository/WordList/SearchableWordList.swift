//
//  WordListFetcher.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import CoreModule

/// Protocol for search queries to the data storage.
protocol SearchableWordList {

    /// Find words containing the string.
    /// - Parameters:
    ///  - string: the string to search for.
    /// - Array of found words.
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
