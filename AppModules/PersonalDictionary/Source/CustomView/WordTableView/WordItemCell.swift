//
//  WordItemCell.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

/// Представление слова (в личном словаре) в виде ячейки таблицы.
final class WordItemCell: UITableViewCell {

    let wordlabel = UILabel()
    let translationLabel = UILabel()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()

    /// Стандартный инициализатор ячейки таблицы.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Задать данные для отображения в представлении.
    /// - Parameters:
    ///  - wordItem: данные о слове из словаря.
    func set(wordItem: WordItem) {
        wordlabel.text = wordItem.text
        translationLabel.text = wordItem.translation
        sourceLangLabel.text = wordItem.sourceLang.shortName
        targetLangLabel.text = wordItem.targetLang.shortName
    }
}
