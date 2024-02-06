//
//  WordItemStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift

protocol NewWordStream {

    /// Для подписки на события добавления новых слов в словарь.
    var newWord: Observable<Word> { get }
}

protocol UpdatedWordStream {

    /// Для подписки на события обновления слов в словаре.
    var updatedWord: Observable<Word> { get }
}

protocol RemovedWordStream {

    /// Для подписки на события удаления слов из словаря.
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
    ///  - word: обновленное слово в словаре.
    func sendUpdatedWord(_ word: Word)
}

/// Отправитель событий удаления слова из личного словаря.
protocol RemovedWordSender {

    /// Отправить событие удаления слова из словаря.
    /// - Parameters:
    ///  - word: удалённое из словаря слово.
    func sendRemovedWord(_ word: Word)
}

protocol WordStream: NewWordStream, NewWordSender,
                     UpdatedWordStream, UpdatedWordSender,
                     RemovedWordStream, RemovedWordSender { }
