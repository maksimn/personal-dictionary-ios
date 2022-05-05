//
//  PDGlobalSettings.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import CoreModule
import UIKit

/// Конфигурация представлений в приложении ("тема")
struct Theme {

    /// Цвет фона в приложении
    let backgroundColor: UIColor

    /// "Золотой" цвет
    let goldColor: UIColor

    /// Цвет ячейки таблицы с информацией о слове
    let wordCellColor: UIColor

    /// Цвет текста в приложении
    let textColor: UIColor

    /// "Вторичный" цвет текста в приложении
    let secondaryTextColor: UIColor

    /// Шрифт стандартного текста обычного размера в приложении.
    let normalFont: UIFont

    private init(backgroundColor: UIColor,
                 goldColor: UIColor,
                 wordCellColor: UIColor,
                 textColor: UIColor,
                 secondaryTextColor: UIColor,
                 normalFont: UIFont) {
        self.backgroundColor = backgroundColor
        self.goldColor = goldColor
        self.wordCellColor = wordCellColor
        self.textColor = textColor
        self.secondaryTextColor = secondaryTextColor
        self.normalFont = normalFont
    }

    static let data = Theme(
        backgroundColor: UIColor(
            light: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0),
            dark: .black
        ),
        goldColor: UIColor(red: 1.00, green: 0.84, blue: 0.00, alpha: 1.00),
        wordCellColor: UIColor(
            light: .white,
            dark: UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        ),
        textColor: UIColor(
            light: .black,
            dark: .white
        ),
        secondaryTextColor: UIColor(
            light: .darkGray,
            dark: .lightGray
        ),
        normalFont: UIFont.systemFont(ofSize: 17)
    )
}
