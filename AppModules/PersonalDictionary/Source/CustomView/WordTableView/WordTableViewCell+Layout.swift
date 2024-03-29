//
//  WordItemCell+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

/// Лэйаут представления слова (в личном словаре) в виде ячейки таблицы.
extension WordTableViewCell {

    /// Высота ячейки
    static let height: CGFloat = 64

    /// Проинициализировать представления ячейки:
    func initViews() {
        clipsToBounds = true
        layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner,
                                    .layerMinXMinYCorner, .layerMaxXMinYCorner]
        selectionStyle = .none
        initWordLabel()
        initSourceLangLabel()
        initTargetLangLabel()
        initTranslationLabel()
        initFavoriteWordLabel()
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner,
                                           .layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func initWordLabel() {
        wordlabel.font = UIFont.boldSystemFont(ofSize: 20)
        wordlabel.numberOfLines = 1
        contentView.addSubview(wordlabel)
    }

    private func initTranslationLabel() {
        translationLabel.font = UIFont.systemFont(ofSize: 17)
        translationLabel.numberOfLines = 1
        contentView.addSubview(translationLabel)
    }

    private func initSourceLangLabel() {
        sourceLangLabel.font = UIFont.boldSystemFont(ofSize: 12)
        sourceLangLabel.numberOfLines = 1
        sourceLangLabel.textAlignment = .right
        contentView.addSubview(sourceLangLabel)
    }

    private func initTargetLangLabel() {
        targetLangLabel.font = UIFont.boldSystemFont(ofSize: 12)
        targetLangLabel.numberOfLines = 1
        targetLangLabel.textAlignment = .right
        contentView.addSubview(targetLangLabel)
    }

    private func initFavoriteWordLabel() {
        favoriteWordLabel.font = UIFont.systemFont(ofSize: 22)
        favoriteWordLabel.text = "★"
        contentView.addSubview(favoriteWordLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let xMax = contentView.bounds.width - 16
        let shortLangNameWidth = max(sourceLangLabel.intrinsicContentSize.width,
                                     targetLangLabel.intrinsicContentSize.width)
        let wordLabelOriginX: CGFloat = 50

        wordlabel.frame = CGRect(origin: CGPoint(x: wordLabelOriginX, y: 10.5),
                                 size: CGSize(width: xMax - shortLangNameWidth - 16, height: 24))
        translationLabel.frame = CGRect(origin: CGPoint(x: wordLabelOriginX, y: 31),
                                        size: CGSize(width: xMax - shortLangNameWidth - 16, height: 24))
        sourceLangLabel.frame = CGRect(origin: CGPoint(x: xMax - shortLangNameWidth, y: 13.5),
                                       size: CGSize(width: shortLangNameWidth, height: 24))
        targetLangLabel.frame = CGRect(origin: CGPoint(x: xMax - shortLangNameWidth, y: 28.5),
                                       size: CGSize(width: shortLangNameWidth, height: 24))
        favoriteWordLabel.frame = CGRect(origin: CGPoint(x: 15, y: 16), size: CGSize(width: 30, height: 30))
    }
}
