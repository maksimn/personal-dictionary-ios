//
//  SearchBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

/// Билдер Фичи "Поиск по словам в словаре".
protocol SearchBuilder {

    /// Создать экран Поиска.
    /// - Returns:
    ///   View controller экрана поиска по словам в словаре.
    func build() -> UIViewController
}
