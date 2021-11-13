//
//  TextLabel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2021.
//

import UIKit

final class TextLabel: UIView {

    private let label = UILabel()

    init() {
        super.init(frame: .zero)
        initWordsNotFoundLabelLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initWordsNotFoundLabelLabel() {
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = NSLocalizedString("No words found", comment: "")
        label.isHidden = true
        addSubview(label)
        label.snp.makeConstraints { make -> Void in
            make.edges.equalTo(self)
        }
    }
}
