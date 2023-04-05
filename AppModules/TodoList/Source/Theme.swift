//
//  Theme.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 11.08.2022.
//

import UIKit

struct Theme {

    let backgroundColor: UIColor
    let textColor: UIColor
    let secondaryTextColor: UIColor
    let cellColor: UIColor
    let darkRed: UIColor
    let darkGreen: UIColor
    let normalFont: UIFont

    private init(
        backgroundColor: UIColor,
        textColor: UIColor,
        secondaryTextColor: UIColor,
        cellColor: UIColor,
        darkRed: UIColor,
        darkGreen: UIColor,
        normalFont: UIFont
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.secondaryTextColor = secondaryTextColor
        self.cellColor = cellColor
        self.darkRed = darkRed
        self.darkGreen = darkGreen
        self.normalFont = normalFont
    }

    static let data = Theme(
        backgroundColor: UIColor(
            light: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0),
            dark: .black
        ),
        textColor: UIColor(
            light: .black,
            dark: .white
        ),
        secondaryTextColor: UIColor(
            light: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3),
            dark: .lightGray
        ),
        cellColor: UIColor(
            light: .white,
            dark: UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
        ),
        darkRed: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1),
        darkGreen: UIColor(red: 0.196, green: 0.843, blue: 0.294, alpha: 1),
        normalFont: UIFont.systemFont(ofSize: 17)
    )
}
