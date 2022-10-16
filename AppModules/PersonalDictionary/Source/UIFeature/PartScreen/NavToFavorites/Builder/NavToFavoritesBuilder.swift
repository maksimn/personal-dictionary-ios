//
//  NavToFavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Билдер фичи "Элемент навигации на экран Избранного".
protocol NavToFavoritesBuilder {

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView
}
