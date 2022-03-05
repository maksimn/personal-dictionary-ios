//
//  WordItemStreamImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift
import RxCocoa

/// Реализация ModelStream для событий со словами в личном словаре.
final class WordItemStreamImpl: WordItemStream {

    private let newWordPublishRelay = PublishRelay<WordItem>()
    private let removedWordPublishRelay = PublishRelay<WordItem>()
    private let updatedWordPublishRelay = PublishRelay<WordItem>()

    private init() {}

    /// Singleton-объект для событий со словами в личном словаре.
    static let instance = WordItemStreamImpl()

    /// Подписка на события добавления новых слов в словарь.
    /// - Returns: Rx observable с потоком событий добавления новых слов в словарь.
    var newWordItem: Observable<WordItem> {
        newWordPublishRelay.asObservable()
    }

    /// Подписка на события удаления слов из словаря.
    /// - Returns: Rx observable с потоком событий удаления слов из словаря.
    var removedWordItem: Observable<WordItem> {
        removedWordPublishRelay.asObservable()
    }

    /// Для подписки на события обновления слова из словаря
    /// - Returns: Rx observable с потоком обновленных слов из словаря.
    var updatedWordItem: Observable<WordItem> {
        updatedWordPublishRelay.asObservable()
    }

    /// Отправить событие добавления нового слова в словарь.
    /// - Parameters:
    ///  - wordItem: новое слово в словаре.
    func sendNewWord(_ wordItem: WordItem) {
        newWordPublishRelay.accept(wordItem)
    }

    /// Отправить событие удаления слова из словаря.
    /// - Parameters:
    ///  - wordItem: удалённое из словаря слово.
    func sendRemovedWordItem(_ wordItem: WordItem) {
        removedWordPublishRelay.accept(wordItem)
    }

    /// Отправить событие обновления слова из словаря.
    /// - Parameters:
    ///  - wordItem: обновленное слово в словаре.
    func sendUpdatedWordItem(_ wordItem: WordItem) {
        updatedWordPublishRelay.accept(wordItem)
    }
}
