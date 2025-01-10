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

    /// Подписка на события добавления новых слов в словарь.
    /// - Returns: Rx observable с потоком событий добавления новых слов в словарь.
    var newWord: Observable<Word> {
        newWordPublishRelay.asObservable()
    }

    /// Отправить событие добавления нового слова в словарь.
    /// - Parameters:
    ///  - word: новое слово в словаре.
    func sendNewWord(_ word: Word) {
        newWordPublishRelay.accept(word)
    }
}

final class RemovedWordStreamImpl: RemovedWordSender, RemovedWordStream {

    private let removedWordPublishRelay = PublishRelay<Word>()

    static let instance = RemovedWordStreamImpl()

    /// Подписка на события удаления слов из словаря.
    /// - Returns: Rx observable с потоком событий удаления слов из словаря.
    var removedWord: Observable<Word> {
        removedWordPublishRelay.asObservable()
    }

    /// Отправить событие удаления слова из словаря.
    /// - Parameters:
    ///  - word: удалённое из словаря слово.
    func sendRemovedWord(_ word: Word) {
        removedWordPublishRelay.accept(word)
    }
}

final class UpdatedWordStreamImpl: UpdatedWordSender, UpdatedWordStream {

    private let updatedWordPublishRelay = PublishRelay<UpdatedWord>()

    private init() {}

    static let instance = UpdatedWordStreamImpl()

    /// Для подписки на события обновления слова из словаря
    /// - Returns: Rx observable с потоком обновленных слов из словаря.
    var updatedWord: Observable<UpdatedWord> {
        updatedWordPublishRelay.asObservable()
    }

    /// Отправить событие обновления слова из словаря.
    /// - Parameters:
    ///  - updatedWord: данные об обновлённом слово в словаре.
    func sendUpdatedWord(_ updatedWord: UpdatedWord) {
        updatedWordPublishRelay.accept(updatedWord)
    }
}
