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

    /// Шрифт стандартного текста обычного размера в приложении.
    let normalFont: UIFont

    private init(backgroundColor: UIColor,
                 normalFont: UIFont) {
        self.backgroundColor = backgroundColor
        self.normalFont = normalFont
    }

    static let data = Theme(
        backgroundColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0),
        normalFont: UIFont.systemFont(ofSize: 17)
    )
}
