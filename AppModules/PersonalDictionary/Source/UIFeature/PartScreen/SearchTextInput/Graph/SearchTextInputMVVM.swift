//
//  SearchTextInputMVVM.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

import UIKit

/// MVVM-граф фичи "Элемент ввода поискового текста".
protocol SearchTextInputMVVM {

    /// Представление фичи.
    var searchBar: UIView { get }

    /// Модель фичи.
    var model: SearchTextInputModel? { get }
}
