//
//  WordListData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.11.2021.
//

/// Данные о списке слов в словаре.
struct WordListData {

    /// Список слов
    let wordList: [WordItem]

    /// Позиция (индекс) изменившегося элемента в этом списке
    let changedItemPosition: Int?
}
