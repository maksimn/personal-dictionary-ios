//
//  TranslationDirectionView.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 18.08.2023.
//

import UIKit

final class TranslationDirectionView: UIView {

    private let theme: Theme
    private let arrowText: String
    private let onSourceLangTap: (() -> Void)?
    private let onTargetLangTap: (() -> Void)?

    private let sourceLangLabel = UILabel()
    private let targetLangLabel = UILabel()
    private let arrowLabel = UILabel()

    init(
        theme: Theme = Theme.data,
        arrowText: String = "⇋",
        onSourceLangTap: (() -> Void)? = nil,
        onTargetLangTap: (() -> Void)? = nil
    ) {
        self.theme = theme
        self.arrowText = arrowText
        self.onSourceLangTap = onSourceLangTap
        self.onTargetLangTap = onTargetLangTap
        super.init(frame: .zero)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(sourceLang: Lang, targetLang: Lang) {
        sourceLangLabel.text = sourceLang.name
        targetLangLabel.text = targetLang.name
    }

    func layoutTo(view: UIView) {
        self.snp.makeConstraints { make in
            make.top.equalTo(view).offset(7.5)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(44)
        }
    }

    private func initViews() {
        [sourceLangLabel, targetLangLabel, arrowLabel].forEach { self.addSubview($0) }
        initSourceLangLabel()
        initTargetLangLabel()
        initArrowLabel()
    }

    @objc
    private func onSourceLangLabelTap() {
        onSourceLangTap?()
    }

    @objc
    private func onTargetLangLabelTap() {
        onTargetLangTap?()
    }

    private func initSourceLangLabel() {
        sourceLangLabel.isUserInteractionEnabled = true
        sourceLangLabel.textColor = theme.textColor
        sourceLangLabel.font = theme.normalFont
        sourceLangLabel.numberOfLines = 1
        sourceLangLabel.textAlignment = .right
        sourceLangLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(12)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self.snp.centerX).offset(-20)
            make.height.equalTo(24)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(onSourceLangLabelTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        sourceLangLabel.addGestureRecognizer(tapGestureRecognizer)
    }

    private func initTargetLangLabel() {
        targetLangLabel.isUserInteractionEnabled = true
        targetLangLabel.textColor = theme.textColor
        targetLangLabel.font = theme.normalFont
        targetLangLabel.numberOfLines = 1
        targetLangLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(12)
            make.leading.equalTo(self.snp.centerX).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(24)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(onTargetLangLabelTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        targetLangLabel.addGestureRecognizer(tapGestureRecognizer)
    }

    private func initArrowLabel() {
        arrowLabel.isUserInteractionEnabled = false
        arrowLabel.textColor = theme.textColor
        arrowLabel.font = theme.normalFont
        arrowLabel.numberOfLines = 1
        arrowLabel.textAlignment = .center
        arrowLabel.text = arrowText
        arrowLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sourceLangLabel)
            make.centerX.equalTo(self)
        }
    }
}
