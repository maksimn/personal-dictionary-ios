//
//  Styles.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

import UIKit

private let appBackgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)

let wordListViewStyles = WordListViewStyles(
    backgroundColor: appBackgroundColor,
    deleteAction: DeleteActionStyles(
        backgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)
    )
)

let newWordViewStyles = NewWordViewStyles(backgroundColor: appBackgroundColor)
