//
//  WordListMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

/// Граф фичи "Список избранных слов".
protocol FavoriteWordListGraph {

    /// View controller для показа экрана/части экрана со списком слов
    var viewController: UIViewController { get }

    /// Модель списка слов
    var model: FavoriteWordListModel? { get }
}
