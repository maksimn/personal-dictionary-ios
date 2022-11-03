//
//  SearchModeMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import UIKit

/// Граф фичи "Выбор режима поиска" по словам из словаря.
protocol SearchModePickerGraph {

    /// Представление фичи.
    var uiview: UIView { get }

    /// Модель фичи.
    var model: SearchModePickerModel? { get }
}
