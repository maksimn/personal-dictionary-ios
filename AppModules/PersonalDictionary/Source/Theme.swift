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

    /// "Золотой" цвет
    let goldColor: UIColor

    /// Шрифт стандартного текста обычного размера в приложении.
    let normalFont: UIFont

    private init(backgroundColor: UIColor,
                 goldColor: UIColor,
                 normalFont: UIFont) {
        self.backgroundColor = backgroundColor
        self.goldColor = goldColor
        self.normalFont = normalFont
    }

    static let standard = Theme(
        backgroundColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0),
        goldColor: UIColor(red: 1.00, green: 0.84, blue: 0.00, alpha: 1.00),
        normalFont: UIFont.systemFont(ofSize: 17)
    )
}
