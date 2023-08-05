//
//  BackButtonFactory.swift
//  TodoList
//
//  Created by Maksim Ivanov on 06.08.2023.
//

import UIKit

struct BackButtonFactory: ButtonFactory {

    private let bundle: Bundle

    init(bundle: Bundle = Bundle.module) {
        self.bundle = bundle
    }

    func create() -> UIButton {
        let backButton = UIButton()
        let backButtonTitle = bundle.moduleLocalizedString("LS_BACK")

        let attributedString = NSMutableAttributedString(string: "\u{2039} \(backButtonTitle)")
        let biggerFontAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 44),
            .baselineOffset: -6
        ]

        attributedString.addAttributes(biggerFontAttributes, range: NSRange(location: 0, length: 1))

        backButton.setAttributedTitle(attributedString, for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)

        return backButton
    }
}
