//
//  NavToSearchBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Билдер фичи "Навигация".
protocol NavToOtherAppBuilder {

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView
}
