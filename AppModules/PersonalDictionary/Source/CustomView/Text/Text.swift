//
//  Text.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 08.11.2022.
//

import UIKit

func Heading(_ text: String) -> UILabel {
    let headingLabel = UILabel()

    headingLabel.textColor = Theme.data.textColor
    headingLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
    headingLabel.numberOfLines = 1
    headingLabel.textAlignment = .left
    headingLabel.text = text

    return headingLabel
}

func SecondaryText(_ text: String) -> UILabel {
    let label = UILabel()

    label.textColor = Theme.data.secondaryTextColor
    label.font = Theme.data.normalFont
    label.numberOfLines = 0
    label.textAlignment = .center
    label.text = text

    return label
}
