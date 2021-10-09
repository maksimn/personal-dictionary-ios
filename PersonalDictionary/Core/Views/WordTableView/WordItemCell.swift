//
//  WordItemCell.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

final class WordItemCell: UITableViewCell {

    let wordlabel = UILabel()
    let translationLabel = UILabel()
    let sourceLangLabel = UILabel()
    let targetLangLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(wordItem: WordItem) {
        wordlabel.text = wordItem.text
        translationLabel.text = wordItem.translation
        sourceLangLabel.text = wordItem.sourceLang.shortName
        targetLangLabel.text = wordItem.targetLang.shortName
    }
}
