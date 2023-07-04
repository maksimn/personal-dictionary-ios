//
//  Text.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 08.11.2022.
//

import UIKit

func secondaryText(_ text: String, _ theme: Theme) -> UILabel {
    let label = UILabel()

    label.textColor = theme.secondaryTextColor
    label.font = theme.normalFont
    label.numberOfLines = 0
    label.textAlignment = .center
    label.text = text

    return label
}
