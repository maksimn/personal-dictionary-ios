//
//  WordListModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// Модель списка слов.
protocol WordListModel: AnyObject {

    /// Стейт модели списка слов.
    var data: WordListData { get set }

    /// Удалить слово по заданному индексу из списка
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
