//
//  WordItemStream.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift

/// Отправитель событий добавления нового слова в личный словарь.
protocol NewWordItemStream: AnyObject {

    /// Отправить событие добавления нового слова в словарь.
    /// - Parameters:
    ///  - wordItem: новое слово в словаре.
    func sendNewWord(_ wordItem: WordItem)
}

/// Общий ModelStream для событий со словами в личном словаре.
protocol WordItemStream: AnyObject {

    /// Для подписки на события добавления новых слов в словарь.
    var newWordItem: Observable<WordItem> { get }

    /// Для подписки на события удаления слова из словаря
    var removedWordItem: Observable<WordItem> { get }

    /// Для подписки на события обновления слова из словаря
    var updatedWordItem: Observable<WordItem> { get }

    /// Отправить событие обновления слова из словаря.
    /// - Parameters:
    ///  - wordItem: обновленное слово в словаре.
    func sendUpdatedWordItem(_ wordItem: WordItem)

    /// Отправить событие удаления слова из словаря.
    /// - Parameters:
    ///  - wordItem: удалённое из словаря слово.
    func sendRemovedWordItem(_ wordItem: WordItem)
}
