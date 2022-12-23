//
//  SearchTextInputMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// Граф фичи "Элемент ввода поискового текста".
protocol SearchTextInputGraph {

    /// Представление фичи.
    var uiview: UIView { get }

    /// Модель фичи.
    var viewModel: SearchTextInputViewModel? { get }
}
