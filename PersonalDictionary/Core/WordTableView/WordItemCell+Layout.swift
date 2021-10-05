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
        selectionStyle = .none
        backgroundColor = .white
        initWordLabel()
    }

    private func initWordLabel() {
        wordlabel.textColor = .black
        wordlabel.font = UIFont.boldSystemFont(ofSize: 20)
        wordlabel.numberOfLines = 1
        contentView.addSubview(wordlabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        wordlabel.frame = CGRect(origin: CGPoint(x: 40, y: 17),
                                 size: CGSize(width: contentView.bounds.width - 32, height: 24))
    }
}
