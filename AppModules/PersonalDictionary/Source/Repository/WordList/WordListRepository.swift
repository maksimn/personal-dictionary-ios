//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import RxSwift

/// Получение списка слов из хранилища личного словаря.
protocol WordListFetcher {

    /// - Returns: список слов из личного словаря.
    var wordList: [WordItem] { get }
}

/// Операции create, update, delete со словами в хранилище личного словаря.
protocol WordItemCUDOperations {

    /// Добавить слово в хранилище личного словаря
    /// - Parameters:
    ///  - wordItem: слово для добавления.
    /// - Returns: Rx completable для обработки завершения операции добавления слова в хранилище.
    func add(_ wordItem: WordItem) -> Completable

    /// Обновить слово в хранилище личного словаря
    /// - Parameters:
    ///  - wordItem: обновленное слово.
    /// - Returns: Rx completable для обработки завершения операции обновления слова в хранилище.
    func update(_ wordItem: WordItem) -> Completable

    /// Удалить слово из хранилища личного словаря
    /// - Parameters:
    ///  - wordItemId: идентификатор слова для его удаления из хранилища.
    /// - Returns: Rx completable для обработки завершения операции удаления слова из хранилища.
    func remove(with wordItemId: WordItem.Id) -> Completable
}

/// Хранилище слов личного словаря.
protocol WordListRepository: WordListFetcher, WordItemCUDOperations {

}
