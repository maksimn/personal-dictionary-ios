//
//  PDGlobalSettings.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import CoreModule
import UIKit

/// View configuration in the application ("theme")
struct Theme {

    /// Background color in the application
    let backgroundColor: UIColor

    /// "Gold" color
    let goldColor: UIColor

    /// Color of the table cell with word information
    let wordCellColor: UIColor

    /// Text color in the application
    let textColor: UIColor

    /// "Secondary" text color in the application
    let secondaryTextColor: UIColor

    /// Standard normal size text font in the application.
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
