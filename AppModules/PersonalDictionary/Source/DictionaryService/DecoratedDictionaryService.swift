//
//  DecoratedDictionaryService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.09.2023.
//

import CoreModule
import SharedFeature

struct CacheableDictionaryService: DictionaryService {

    let dictionaryService: DictionaryService
    let dictionaryEntryDbInserter: DictionaryEntryDbInserter
    let decoder: DictionaryEntryDecoder
    let updateWordDbWorker: UpdateWordDbWorker

    func fetchDictionaryEntry(for word: Word) async throws -> WordData {
        let wordData = try await dictionaryService.fetchDictionaryEntry(for: word)
        let insertedWordData = try await dictionaryEntryDbInserter.insert(entry: wordData.entry, for: wordData.word)
        let dictionaryEntry = try decoder.decode(insertedWordData.entry)
        var word = insertedWordData.word

        word.translation = dictionaryEntry.mainTranslation

        _ = try await updateWordDbWorker.update(word: word)

        return WordData(word: word, entry: insertedWordData.entry)
    }
}

struct IndexedSearchByTranslationDictionaryService: DictionaryService {

    let dictionaryService: DictionaryService
    let createWordTranslationIndexDbWorker: CreateWordTranslationIndexDbWorker

    func fetchDictionaryEntry(for word: Word) async throws -> WordData {
        let wordData = try await dictionaryService.fetchDictionaryEntry(for: word)

        return try await createWordTranslationIndexDbWorker.createTranslationIndexFor(wordData: wordData)
    }
}

struct ErrorSendableDictionaryService: DictionaryService {

    let dictionaryService: DictionaryService
    let sharedMessageSender: SharedMessageSender
    let messageTemplate: String

    func fetchDictionaryEntry(for word: Word) async throws -> WordData {
        do {
            return try await dictionaryService.fetchDictionaryEntry(for: word)
        } catch {
            let message = String(format: messageTemplate, word.text)

            sharedMessageSender.send(sharedMessage: message)
            throw error
        }
    }
}

struct DictionaryServiceLog: DictionaryService {

    let dictionaryService: DictionaryService
    let logger: Logger

    func fetchDictionaryEntry(for word: Word) async throws -> WordData {
        logger.log("PONS Dictionary Entry Request Start\nword = \(word)", level: .info)

        do {
            let result = try await dictionaryService.fetchDictionaryEntry(for: word)

            logger.log("PONS Dictionary Entry Request Success\nword = \(result)", level: .info)

            return result
        } catch {
            logger.log("PONS Dictionary Entry Request Error\nerror = \(error)", level: .warn)
            throw error
        }
    }
}
