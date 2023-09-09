//
//  DecoratedDictionaryService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.09.2023.
//

import SharedFeature
import RxSwift

struct DictionaryServiceImpl: DictionaryService {

    let dictionaryService: DictionaryService

    func fetchDictionaryEntry(for word: Word) -> Single<WordData> {
        dictionaryService.fetchDictionaryEntry(for: word)
    }
}

struct CacheableDictionaryService: DictionaryService {

    let dictionaryService: DictionaryService
    let dictionaryEntryDbWorker: DictionaryEntryDbWorker
    let decoder: DictionaryEntryDecoder
    let updateWordDbWorker: UpdateWordDbWorker

    func fetchDictionaryEntry(for word: Word) -> Single<WordData> {
        dictionaryService
            .fetchDictionaryEntry(for: word)
            .flatMap { wordData in
                dictionaryEntryDbWorker.insert(entry: wordData.entry, for: wordData.word)
            }
            .flatMap { wordData in
                let dictionaryEntry = try decoder.decode(wordData.entry, word: word)
                var word = wordData.word

                word.translation = dictionaryEntry.first ?? ""

                return updateWordDbWorker.update(word: word)
                    .map { _ in
                        WordData(word: word, entry: wordData.entry)
                    }
            }
    }
}

struct ErrorSendableDictionaryService: DictionaryService {

    let dictionaryService: DictionaryService
    let sharedMessageSender: SharedMessageSender
    let messageTemplate: String

    func fetchDictionaryEntry(for word: Word) -> Single<WordData> {
        dictionaryService
            .fetchDictionaryEntry(for: word)
            .do(onError: { _ in
                let message = String(format: messageTemplate, word.text)

                self.sharedMessageSender.send(sharedMessage: message)
            })
    }
}
