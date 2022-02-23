//
//  NavToNewWordBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Билдер фичи "Навигация на экран добавления нового слова".
protocol NavToNewWordBuilder {

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView
}
