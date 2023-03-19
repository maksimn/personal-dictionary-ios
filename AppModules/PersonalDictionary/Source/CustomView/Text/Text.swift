//
//  Text.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 08.11.2022.
//

import UIKit

func Heading(_ text: String, _ theme: Theme) -> UILabel {
    let headingLabel = UILabel()

    headingLabel.textColor = theme.textColor
    headingLabel.font = UIFont.systemFont(ofSize: 28, weight: .medium)
    headingLabel.numberOfLines = 1
    headingLabel.textAlignment = .left
    headingLabel.text = text

    return headingLabel
}

func SecondaryText(_ text: String, _ theme: Theme) -> UILabel {
    let label = UILabel()

    label.textColor = theme.secondaryTextColor
    label.font = theme.normalFont
    label.numberOfLines = 0
    label.textAlignment = .center
    label.text = text

    return label
}
