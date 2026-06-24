//
//  WordStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

protocol NewWordStream {

    /// To subscribe for events of an appearance of a new word in the dictionary
    var newWord: AsyncStream<Word> { get }
}

protocol UpdatedWordStream {

    /// To subscribe for events of an update of a word in the dictionary
    var updatedWord: AsyncStream<UpdatedWord> { get }
}

protocol RemovedWordStream {

    /// To subscribe for events of a deletion of a word in the dictionary
    var removedWord: AsyncStream<Word> { get }
}

/// Sender of events for adding a new word to the personal dictionary.
protocol NewWordSender {

    /// Send an event of adding a new word to the dictionary.
    /// - Parameters:
    ///  - word: new word in the dictionary.
    func sendNewWord(_ word: Word)
}

/// Sender of events for updating a word in the personal dictionary.
protocol UpdatedWordSender {

    /// Send an event of updating a word in the dictionary.
    /// - Parameters:
    ///  - updatedWord: data about the updated word in the dictionary.
    func sendUpdatedWord(_ updatedWord: UpdatedWord)
}

/// Sender of events for deleting a word from the personal dictionary.
protocol RemovedWordSender {

    /// Send an event of deleting a word from the dictionary.
    /// - Parameters:
    ///  - word: word removed from the dictionary.
    func sendRemovedWord(_ word: Word)
}
