//
//  WordItemStreamImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2021.
//

import RxSwift
import RxCocoa

/// Реализация ModelStream для событий со словами в личном словаре.
final class WordStreamImpl: WordStream {

    private let newWordPublishRelay = PublishRelay<Word>()
    private let removedWordPublishRelay = PublishRelay<Word>()
    private let updatedWordPublishRelay = PublishRelay<UpdatedWord>()

    private init() {}

    /// Singleton-объект для событий со словами в личном словаре.
    static let instance = WordStreamImpl()

    /// Подписка на события добавления новых слов в словарь.
    /// - Returns: Rx observable с потоком событий добавления новых слов в словарь.
    var newWord: Observable<Word> {
        newWordPublishRelay.asObservable()
    }

    /// Подписка на события удаления слов из словаря.
    /// - Returns: Rx observable с потоком событий удаления слов из словаря.
    var removedWord: Observable<Word> {
        removedWordPublishRelay.asObservable()
    }

    /// Для подписки на события обновления слова из словаря
    /// - Returns: Rx observable с потоком обновленных слов из словаря.
    var updatedWord: Observable<UpdatedWord> {
        updatedWordPublishRelay.asObservable()
    }

    /// Отправить событие добавления нового слова в словарь.
    /// - Parameters:
    ///  - word: новое слово в словаре.
    func sendNewWord(_ word: Word) {
        newWordPublishRelay.accept(word)
    }

    /// Отправить событие удаления слова из словаря.
    /// - Parameters:
    ///  - word: удалённое из словаря слово.
    func sendRemovedWord(_ word: Word) {
        removedWordPublishRelay.accept(word)
    }

    /// Отправить событие обновления слова из словаря.
    /// - Parameters:
    ///  - updatedWord: данные об обновлённом слово в словаре.
    func sendUpdatedWord(_ updatedWord: UpdatedWord) {
        updatedWordPublishRelay.accept(updatedWord)
    }
}
