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
    var wordList: [Word] { get }
}

/// Получение списка избранных слов из хранилища личного словаря.
protocol FavoriteWordListFetcher {

    /// - Returns: список  избранных слов из личного словаря.
    var favoriteWordList: [Word] { get }
}

/// Операции create, update, delete со словами в хранилище личного словаря.
protocol WordCUDOperations {

    /// Добавить слово в хранилище личного словаря
    /// - Parameters:
    ///  - word: слово для добавления.
    /// - Returns: Rx completable для обработки завершения операции добавления слова в хранилище.
    func add(_ word: Word) -> Completable

    /// Обновить слово в хранилище личного словаря
    /// - Parameters:
    ///  - word: обновленное слово.
    /// - Returns: Rx completable для обработки завершения операции обновления слова в хранилище.
    func update(_ word: Word) -> Completable

    /// Удалить слово из хранилища личного словаря
    /// - Parameters:
    ///  - wordId: идентификатор слова для его удаления из хранилища.
    /// - Returns: Rx completable для обработки завершения операции удаления слова из хранилища.
    func remove(with wordId: Word.Id) -> Completable
}

/// Протокол для поисковых запросов к хранилищу данных.
protocol SearchableWordList {

    /// Найти слова, содержащие строку.
    /// - Parameters:
    ///  - string: строка для поиска.
    /// - Массив найденных слов.
    func findWords(contain string: String) -> [Word]

    /// Найти слова, перевод которых содержит строку.
    /// - Parameters:
    ///  - string: строка для поиска.
    /// - Массив найденных слов.
    func findWords(whereTranslationContains string: String) -> [Word]
}

/// Хранилище слов личного словаря.
protocol WordListRepository: WordListFetcher,
                             FavoriteWordListFetcher,
                             WordCUDOperations,
                             SearchableWordList {
}
