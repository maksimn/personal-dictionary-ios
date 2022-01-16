//
//  WordListMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

/// MVVM-граф фичи "Список слов".
protocol WordListMVVM {

    /// View controller для показа экрана/части экрана со списком слов
    var viewController: UIViewController { get }

    /// Модель списка слов
    var model: WordListModel? { get }
}
