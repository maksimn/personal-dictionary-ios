//
//  WordItemCell+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

extension WordItemCell {

    static let height: CGFloat = 64

    func initViews() {
        clipsToBounds = true
        layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner,
                                    .layerMinXMinYCorner, .layerMaxXMinYCorner]
        selectionStyle = .none
        backgroundColor = .white
        initWordLabel()
        initSourceLangLabel()
        initTargetLangLabel()
        initTranslationLabel()
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner,
                                           .layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func initWordLabel() {
        wordlabel.textColor = .black
        wordlabel.font = UIFont.boldSystemFont(ofSize: 20)
        wordlabel.numberOfLines = 1
        contentView.addSubview(wordlabel)
    }

    private func initTranslationLabel() {
        translationLabel.textColor = .black
        translationLabel.font = UIFont.systemFont(ofSize: 17)
        translationLabel.numberOfLines = 1
        contentView.addSubview(translationLabel)
    }

    private func initSourceLangLabel() {
        sourceLangLabel.textColor = .darkGray
        sourceLangLabel.font = UIFont.boldSystemFont(ofSize: 12)
        sourceLangLabel.numberOfLines = 1
        contentView.addSubview(sourceLangLabel)
    }

    private func initTargetLangLabel() {
        targetLangLabel.textColor = .darkGray
        targetLangLabel.font = UIFont.boldSystemFont(ofSize: 12)
        targetLangLabel.numberOfLines = 1
        contentView.addSubview(targetLangLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let xMax = contentView.bounds.width - 16
        let shortLangNameWidth: CGFloat = 30
        wordlabel.frame = CGRect(origin: CGPoint(x: 40, y: 10.5),
                                 size: CGSize(width: xMax - shortLangNameWidth - 16, height: 24))
        translationLabel.frame = CGRect(origin: CGPoint(x: 40, y: 31),
                                        size: CGSize(width: xMax - shortLangNameWidth - 16, height: 24))
        sourceLangLabel.frame = CGRect(origin: CGPoint(x: xMax - shortLangNameWidth, y: 13.5),
                                       size: CGSize(width: shortLangNameWidth, height: 24))
        targetLangLabel.frame = CGRect(origin: CGPoint(x: xMax - shortLangNameWidth, y: 28.5),
                                       size: CGSize(width: shortLangNameWidth, height: 24))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        wordlabel.text = nil
        translationLabel.text = nil
        sourceLangLabel.text = nil
        targetLangLabel.text = nil
    }
}
