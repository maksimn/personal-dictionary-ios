//
//  LangPickerMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

/// Граф фичи "Выбор языка".
protocol LangPickerGraph {

    /// Представление выбора языка
    var uiview: UIView { get }

    /// Модель представления выбора языка
    var viewmodel: LangPickerViewModel { get }
}
