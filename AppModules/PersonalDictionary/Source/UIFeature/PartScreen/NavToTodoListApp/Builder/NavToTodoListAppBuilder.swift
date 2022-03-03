//
//  NavToSearchBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 21.02.2022.
//

import UIKit

/// Билдер фичи "Навигация к другому продукту/приложению в супераппе".
protocol NavToOtherAppBuilder {

    /// Создать фичу.
    /// - Returns: представление фичи.
    func build() -> UIView
}
