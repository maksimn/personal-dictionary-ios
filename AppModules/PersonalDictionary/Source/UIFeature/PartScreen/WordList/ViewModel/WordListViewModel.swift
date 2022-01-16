//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// Модель представления списка слов.
protocol WordListViewModel: AnyObject {

    /// Данные модели представления.
    var wordListData: WordListData { get set }

    /// Удалить слово из модели по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func remove(at position: Int)

    /// Отправить оповещение об удалении слова.
    /// - Parameters:
    ///  - wordItem: удаленное слово.
    func sendRemovedWordItem(_ wordItem: WordItem)

    /// Запросить перевод для слов в списке, расположенных в заданном интервале индексов.
    /// - Parameters:
    ///  - startPosition: позиция (индекс) начального слова.
    ///  - endPosition: верхняя граница индексов слов для перевода (не включая).
    func requestTranslationsIfNeededWithin(startPosition: Int, endPosition: Int)
}
