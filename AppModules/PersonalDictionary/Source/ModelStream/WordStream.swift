//
//  WordItemStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift

/// Общий ModelStream для подписки на события со словами в личном словаре.
protocol ReadableWordStream {

    /// Для подписки на события добавления новых слов в словарь.
    var newWord: Observable<Word> { get }

    /// Для подписки на события удаления слова из словаря
    var removedWord: Observable<Word> { get }

    /// Для подписки на события обновления слова из словаря
    var updatedWord: Observable<Word> { get }
}

/// Отправитель событий добавления нового слова в личный словарь.
protocol NewWordStream {

    /// Отправить событие добавления нового слова в словарь.
    /// - Parameters:
    ///  - word: новое слово в словаре.
    func sendNewWord(_ word: Word)
}

/// ModelStream для отправки событий обновления слова в личном словаре.
protocol UpdatedWordStream {

    /// Отправить событие обновления слова из словаря.
    /// - Parameters:
    ///  - word: обновленное слово в словаре.
    func sendUpdatedWord(_ word: Word)
}

/// ModelStream для отправки событий удаления слова из личного словаря.
protocol RemovedWordStream {

    /// Отправить событие удаления слова из словаря.
    /// - Parameters:
    ///  - word: удалённое из словаря слово.
    func sendRemovedWord(_ word: Word)
}

/// Общий WordStream для событий со словами в личном словаре.
protocol WordStream: ReadableWordStream,
                     NewWordStream,
                     UpdatedWordStream,
                     RemovedWordStream { }
