//
//  PDGlobalSettings.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import UIKit

/// Конфигурация представлений в приложении ("тема")
struct Theme {

    /// Цвет фона в приложении
    let backgroundColor: UIColor

    private init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }

    static let data = Theme(backgroundColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0))
}
