//
//  WordListFetcher.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import CoreModule

/// Получение списка слов из хранилища личного словаря.
protocol WordListFetcher {

    /// - Returns: список слов из личного словаря.
    func wordList() throws -> [Word]
}

struct RealmWordListFetcher: WordListFetcher {

    func wordList() throws -> [Word] {
        try realmWordListFilter { $0 }
    }
}

struct WordListFetcherLog: WordListFetcher {

    let wordListFetcher: WordListFetcher
    let logger: Logger

    func wordList() throws -> [Word] {
        do {
            logger.log("Fetching word list from the device storage...", level: .info)

            let result = try wordListFetcher.wordList()

            logger.log("Word list fetched from the device storage: \(result)", level: .info)

            return result
        } catch {
            logger.log("Error of fetching the word list from the device storage: \(error)", level: .error)

            throw error
        }
    }
}
