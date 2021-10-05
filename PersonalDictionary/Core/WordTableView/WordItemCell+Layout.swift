//
//  WordItemCell+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

import UIKit

extension WordItemCell {

    func initViews() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        selectionStyle = .none
        backgroundColor = .white
        initWordLabel()
    }

    private func initWordLabel() {
        wordlabel.textColor = .black
        wordlabel.font = UIFont.boldSystemFont(ofSize: 17)
        wordlabel.numberOfLines = 1
        wordlabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 68
        contentView.addSubview(wordlabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        wordlabel.frame = CGRect(origin: CGPoint(x: 40, y: 17),
                                 size: CGSize(width: UIScreen.main.bounds.width - 68, height: 24))
    }
}
