//
//  DecoratedDictionaryService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.09.2023.
//

import CoreModule
import SharedFeature
import RxSwift

struct CacheableDictionaryService: DictionaryService {

    let dictionaryService: DictionaryService
    let dictionaryEntryDbInserter: DictionaryEntryDbInserter
    let decoder: DictionaryEntryDecoder
    let updateWordDbWorker: UpdateWordDbWorker

    func fetchDictionaryEntry(for word: Word) -> Single<WordData> {
        dictionaryService
            .fetchDictionaryEntry(for: word)
            .flatMap { wordData in
                dictionaryEntryDbInserter.insert(entry: wordData.entry, for: wordData.word)
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

struct DictionaryServiceLog: DictionaryService {

    let dictionaryService: DictionaryService
    let logger: Logger

    func fetchDictionaryEntry(for word: Word) -> Single<WordData> {
        logger.log("PONS Dictionary Entry Request Start\nword = \(word)", level: .info)

        let result = dictionaryService.fetchDictionaryEntry(for: word)

        let loggedResult = result.do(
            onSuccess: { word in
                logger.log("PONS Dictionary Entry Request Success\nword = \(word)", level: .info)
            },
            onError: { error in
                logger.log("PONS Dictionary Entry Request Error\nerror = \(error)", level: .warn)
            }
        )

        return loggedResult
    }
}
