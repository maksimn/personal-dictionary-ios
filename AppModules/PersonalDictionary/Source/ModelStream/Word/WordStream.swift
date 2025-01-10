//
//  WordStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift

protocol NewWordStream {

    /// To subscribe for events of an appearance of a new word in the dictionary
    var newWord: Observable<Word> { get }
}

protocol UpdatedWordStream {

    /// To subscribe for events of an update of a word in the dictionary
    var updatedWord: Observable<UpdatedWord> { get }
}

protocol RemovedWordStream {

    /// To subscribe for events of a deletion of a word in the dictionary
    var removedWord: Observable<Word> { get }
}

/// Отправитель событий добавления нового слова в личный словарь.
protocol NewWordSender {

    /// Отправить событие добавления нового слова в словарь.
    /// - Parameters:
    ///  - word: новое слово в словаре.
    func sendNewWord(_ word: Word)
}

/// Отправитель событий обновления слова в личном словаре.
protocol UpdatedWordSender {

    /// Отправить событие обновления слова из словаря.
    /// - Parameters:
    ///  - updatedWord: данные об обновлённом слово в словаре.
    func sendUpdatedWord(_ updatedWord: UpdatedWord)
}

/// Отправитель событий удаления слова из личного словаря.
protocol RemovedWordSender {

    /// Отправить событие удаления слова из словаря.
    /// - Parameters:
    ///  - word: удалённое из словаря слово.
    func sendRemovedWord(_ word: Word)
}
