//
//  NavToFavoriteWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Билдер фичи
protocol NavToFavoriteWordListBuilder {

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView
}
