//
//  NewWordBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

/// Билдер Фичи "Добавление нового слова" в личный словарь.
protocol NewWordBuilder {

    /// Создать экран фичи
    /// - Returns:
    ///  - экран фичи  "Добавление нового слова".
    func build() -> UIViewController
}
