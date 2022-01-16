//
//  WordItemStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift

/// ModelStream для чтения событий со словами в личном словаре.
protocol ReadableWordItemStream: AnyObject {

    /// Для подписки на события добавления новых слов в словарь.
    var newWordItem: Observable<WordItem> { get }

    /// Для подписки на события удаления слова из словаря
    var removedWordItem: Observable<WordItem> { get }
}

/// Отправитель событий добавления нового слова в личный словарь.
protocol NewWordItemStream: AnyObject {

    /// Отправить событие добавления нового слова в словарь.
    /// - Parameters:
    ///  - wordItem: новое слово в словаре.
    func sendNewWord(_ wordItem: WordItem)
}

/// Отправитель событий удаления слова из личного словаря.
protocol RemovedWordItemStream: AnyObject {

    /// Отправить событие удаления слова из словаря.
    /// - Parameters:
    ///  - wordItem: удалённое из словаря слово.
    func sendRemovedWordItem(_ wordItem: WordItem)
}

/// Общий ModelStream для событий со словами в личном словаре.
protocol WordItemStream: ReadableWordItemStream, NewWordItemStream, RemovedWordItemStream {
}
