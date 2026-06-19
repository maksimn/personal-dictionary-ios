//
//  WordTableViewCell.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

/// Word representation as a table cell.
final class WordTableViewCell: UITableViewCell {

    let wordlabel = UILabel()
    let translationLabel = UILabel()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()
    let favoriteWordLabel = UILabel()

    /// Standard table cell initializer.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Set the data to display in the view.
    /// - Parameters:
    ///  - word: word data from the dictionary.
    func set(word: Word, _ theme: Theme) {
        wordlabel.text = word.text
        translationLabel.text = word.translation
        sourceLangLabel.text = word.sourceLang.shortName
        targetLangLabel.text = word.targetLang.shortName
        favoriteWordLabel.isHidden = !word.isFavorite
        backgroundColor = theme.wordCellColor
        wordlabel.textColor = theme.textColor
        translationLabel.textColor = theme.textColor
        sourceLangLabel.textColor = theme.secondaryTextColor
        targetLangLabel.textColor = theme.secondaryTextColor
        favoriteWordLabel.textColor = theme.goldColor
    }
}
