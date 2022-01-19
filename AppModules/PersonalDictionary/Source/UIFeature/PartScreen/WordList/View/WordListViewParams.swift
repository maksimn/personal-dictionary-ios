//
//  WordListViewParams.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.11.2021.
//

import UIKit

/// Параметры представления списка слов.
struct WordListViewParams {

    /// Цвет фона
    let backgroundColor: UIColor

    /// Высота элемента списка (таблицы)
    let itemHeight: CGFloat

    /// Класс ячейки таблицы
    let cellClass: AnyClass

    /// Reuse Id ячейки таблицы
    let cellReuseIdentifier: String

    /// Радиус скругления углов ячейки таблицы
    let cellCornerRadius: CGFloat

    /// Параметры делегата таблицы
    let delegateParams: WordTableDelegateParams
}
