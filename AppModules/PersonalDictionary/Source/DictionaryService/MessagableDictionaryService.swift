//
//  MessagableDictionaryService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.09.2023.
//

import SharedFeature
import RxSwift

struct MessagableDictionaryService: DictionaryService {

    let dictionaryService: DictionaryService
    let sharedMessageSender: SharedMessageSender
    let messageTemplate: String

    func fetchDictionaryEntry(for word: Word) -> Single<Word> {
        dictionaryService
            .fetchDictionaryEntry(for: word)
            .do(onError: { _ in
                let message = String(format: messageTemplate, word.text)

                self.sharedMessageSender.send(sharedMessage: message)
            })
    }
}
