//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import RealmSwift
import RxSwift

/// Получение списка слов из хранилища личного словаря.
protocol WordListFetcher {

    /// - Returns: список слов из личного словаря.
    func wordList() throws -> [Word]
}

protocol CreateWordDbWorker {

    /// Добавить слово в хранилище личного словаря
    /// - Parameters:
    ///  - word: слово для добавления.
    /// - Returns: Rx single для обработки завершения операции добавления слова в хранилище.
    func create(word: Word) -> Single<Word>
}

protocol UpdateWordDbWorker {

    /// Обновить слово в хранилище личного словаря
    /// - Parameters:
    ///  - word: обновленное слово.
    /// - Returns: Rx single для обработки завершения операции обновления слова в хранилище.
    func update(word: Word) -> Single<Word>
}

protocol DeleteWordDbWorker {

    /// Удалить слово из хранилища личного словаря
    /// - Parameters:
    ///  - word: слово для его удаления из хранилища.
    /// - Returns: Rx single для обработки завершения операции удаления слова из хранилища.
    func delete(word: Word) -> Single<Word>
}

/// Получение списка избранных слов из хранилища личного словаря.
protocol FavoriteWordListFetcher {

    /// - Returns: список  избранных слов из личного словаря.
    func favoriteWordList() throws -> [Word]
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
