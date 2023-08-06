//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.10.2021.
//

import RealmSwift
import RxSwift

protocol WordListFetcher {

    func wordList() throws -> [Word]
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
    /// - Returns: Rx single для обработки завершения операции добавления слова в хранилище.
    func add(_ word: Word) -> Single<Word>

    /// Обновить слово в хранилище личного словаря
    /// - Parameters:
    ///  - word: обновленное слово.
    /// - Returns: Rx single для обработки завершения операции обновления слова в хранилище.
    func update(_ word: Word) -> Single<Word>

    /// Удалить слово из хранилища личного словаря
    /// - Parameters:
    ///  - wordId: идентификатор слова для его удаления из хранилища.
    /// - Returns: Rx single для обработки завершения операции удаления слова из хранилища.
    func remove(_ word: Word) -> Single<Word>
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
protocol WordListRepository: FavoriteWordListFetcher,
                             WordCUDOperations,
                             SearchableWordList {
}
