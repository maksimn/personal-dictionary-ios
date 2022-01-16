//
//  LangPickerMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2021.
//

import UIKit

/// MVVM-граф фичи "Выбор языка".
protocol LangPickerMVVM {

    /// Представление выбора языка
    var uiview: UIView? { get }

    /// Модель для выбора языка
    var model: LangPickerModel? { get }
}
