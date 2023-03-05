//
//  WordListGraph.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

/// Граф фичи "Список слов".
protocol WordListGraph {

    var view: UIView { get }

    /// Модель списка слов
    var viewModel: WordListViewModel { get }
}
