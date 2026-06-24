//
//  WordItemStreamImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import Foundation

final class NewWordStreamImpl: NewWordSender, NewWordStream {

    private var continuation: AsyncStream<Word>.Continuation?

    private init() {}

    static let instance = NewWordStreamImpl()

    /// Subscribe to new word addition events in the dictionary.
    /// - Returns: Async stream with a stream of new word addition events.
    var newWord: AsyncStream<Word> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    /// Send a new word addition event to the dictionary.
    /// - Parameters:
    ///  - word: the new word in the dictionary.
    func sendNewWord(_ word: Word) {
        continuation?.yield(word)
    }
}

final class RemovedWordStreamImpl: RemovedWordSender, RemovedWordStream {

    private var continuation: AsyncStream<Word>.Continuation?

    static let instance = RemovedWordStreamImpl()

    /// Subscribe to word removal events from the dictionary.
    /// - Returns: Async stream with a stream of word removal events.
    var removedWord: AsyncStream<Word> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    /// Send a word removal event from the dictionary.
    /// - Parameters:
    ///  - word: the word removed from the dictionary.
    func sendRemovedWord(_ word: Word) {
        continuation?.yield(word)
    }
}

final class UpdatedWordStreamImpl: UpdatedWordSender, UpdatedWordStream {

    private var continuation: AsyncStream<UpdatedWord>.Continuation?

    private init() {}

    static let instance = UpdatedWordStreamImpl()

    /// Subscribe to word update events from the dictionary.
    /// - Returns: Async stream with a stream of updated words from the dictionary.
    var updatedWord: AsyncStream<UpdatedWord> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    /// Send a word update event from the dictionary.
    /// - Parameters:
    ///  - updatedWord: data about the updated word in the dictionary.
    func sendUpdatedWord(_ updatedWord: UpdatedWord) {
        continuation?.yield(updatedWord)
    }
}
