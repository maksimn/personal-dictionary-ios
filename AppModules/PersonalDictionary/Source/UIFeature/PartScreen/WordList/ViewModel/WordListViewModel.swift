//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// Модель представления списка слов.
protocol WordListViewModel {

    /// Данные модели представления.
    var wordList: BindableWordList { get }

    func select(at position: Int)

    /// Удалить слово из модели по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func remove(at position: Int)

    /// Переключить значение флага "избранности" (isFavorite) для слова по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func toggleWordIsFavorite(at position: Int)
}
