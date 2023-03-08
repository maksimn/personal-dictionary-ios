//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift

/// Модель представления списка слов.
protocol WordListViewModel {

    /// Данные модели представления.
    var wordList: BindableWordList { get }

    /// Удалить слово из модели по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func remove(at position: Int)

    /// Переключить значение флага "избранности" (isFavorite) для слова по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func toggleWordIsFavorite(at position: Int)

    /// Запросить перевод для слов в списке, расположенных в заданном интервале индексов.
    /// - Parameters:
    ///  - start: позиция (индекс) начального слова.
    ///  - end: верхняя граница индексов слов для перевода (не включая).
    func fetchTranslationsIfNeededWithin(start: Int, end: Int) -> Completable
}
