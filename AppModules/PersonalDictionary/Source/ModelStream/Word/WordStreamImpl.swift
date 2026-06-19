//
//  WordItemStreamImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift
import RxCocoa

final class NewWordStreamImpl: NewWordSender, NewWordStream {

    private let newWordPublishRelay = PublishRelay<Word>()

    private init() {}

    static let instance = NewWordStreamImpl()

    /// Subscribe to new word addition events in the dictionary.
    /// - Returns: Rx observable with a stream of new word addition events.
    var newWord: Observable<Word> {
        newWordPublishRelay.asObservable()
    }

    /// Send a new word addition event to the dictionary.
    /// - Parameters:
    ///  - word: the new word in the dictionary.
    func sendNewWord(_ word: Word) {
        newWordPublishRelay.accept(word)
    }
}

final class RemovedWordStreamImpl: RemovedWordSender, RemovedWordStream {

    private let removedWordPublishRelay = PublishRelay<Word>()

    static let instance = RemovedWordStreamImpl()

    /// Subscribe to word removal events from the dictionary.
    /// - Returns: Rx observable with a stream of word removal events.
    var removedWord: Observable<Word> {
        removedWordPublishRelay.asObservable()
    }

    /// Send a word removal event from the dictionary.
    /// - Parameters:
    ///  - word: the word removed from the dictionary.
    func sendRemovedWord(_ word: Word) {
        removedWordPublishRelay.accept(word)
    }
}

final class UpdatedWordStreamImpl: UpdatedWordSender, UpdatedWordStream {

    private let updatedWordPublishRelay = PublishRelay<UpdatedWord>()

    private init() {}

    static let instance = UpdatedWordStreamImpl()

    /// Subscribe to word update events from the dictionary.
    /// - Returns: Rx observable with a stream of updated words from the dictionary.
    var updatedWord: Observable<UpdatedWord> {
        updatedWordPublishRelay.asObservable()
    }

    /// Send a word update event from the dictionary.
    /// - Parameters:
    ///  - updatedWord: data about the updated word in the dictionary.
    func sendUpdatedWord(_ updatedWord: UpdatedWord) {
        updatedWordPublishRelay.accept(updatedWord)
    }
}
