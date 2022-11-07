//
//  WordTableViewCell.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

/// Представление слова (в личном словаре) в виде ячейки таблицы.
final class WordTableViewCell: UITableViewCell {

    let wordlabel = UILabel()
    let translationLabel = UILabel()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()
    let favoriteWordLabel = UILabel()

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
    ///  - word: данные о слове из словаря.
    func set(word: Word) {
        wordlabel.text = word.text
        translationLabel.text = word.translation
        sourceLangLabel.text = word.sourceLang.shortName
        targetLangLabel.text = word.targetLang.shortName
        favoriteWordLabel.isHidden = !word.isFavorite
    }
}
