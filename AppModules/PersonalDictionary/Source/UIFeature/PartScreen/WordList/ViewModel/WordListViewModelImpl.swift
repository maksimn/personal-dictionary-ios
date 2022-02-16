//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import RxSwift
import RxRelay

/// Реализация модели представления списка слов.
final class WordListViewModelImpl: WordListViewModel {

    private let model: WordListModel

    /// Инициализатор.
    /// - Parameters:
    ///  - model: модель списка слов.
    init(model: WordListModel) {
        self.model = model
    }

    /// Данные модели представления.
    let wordList = BehaviorRelay<[WordItem]>(value: [])

    /// Удалить слово из модели по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func remove(at position: Int) {
        model.remove(at: position)
    }

    /// Запросить перевод для слов в списке, расположенных в заданном интервале индексов.
    /// - Parameters:
    ///  - startPosition: позиция (индекс) начального слова.
    ///  - endPosition: верхняя граница индексов слов для перевода (не включая).
    func requestTranslationsIfNeededWithin(startPosition: Int, endPosition: Int) {
        model.requestTranslationsIfNeededWithin(startPosition: startPosition, endPosition: endPosition)
    }

    /// Переключить значение флага "избранности" (isFavorite) для слова по заданному индексу из списка
    /// - Parameters:
    ///  - position: позиция (индекс) слова в списке.
    func toggleWordItemIsFavorite(at position: Int) {
        model.toggleWordItemIsFavorite(at: position)
    }
}
