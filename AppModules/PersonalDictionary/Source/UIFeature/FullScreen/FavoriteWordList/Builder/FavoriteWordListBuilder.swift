//
//  FavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.11.2021.
//

import UIKit

/// Билдер фичи "Экран списка избранных слов".
protocol FavoriteWordListBuilder {

    /// Создать экран.
    /// - Returns:
    ///  - View controller экрана.
    func build() -> UIViewController
}
