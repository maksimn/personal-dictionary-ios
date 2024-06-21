//
//  NewWordViewVC+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

/// Лэйаут экрана добавления нового слова в личный словарь.
extension NewWordViewController {

    /// Инициализация представлений экрана.
    func initViews() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        addSubviews()
        initContentView()
        translationDirectionView.layoutTo(view: contentView)
        initTextField()
        initOkButton()
    }

    private func addSubviews() {
        [contentView, translationDirectionView, textField, okButton].forEach { view.addSubview($0) }
    }

    private func initContentView() {
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = theme.backgroundColor
        contentView.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(12)
            make.height.equalTo(176)
        }
    }

    private func initTextField() {
        textField.placeholder = params.textFieldPlaceholder
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.textColor = .black
        textField.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 62, left: 12, bottom: 74, right: 12))
        }
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func initOkButton() {
        okButton.setTitle(params.okText, for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = .green
        okButton.layer.cornerRadius = 8
        okButton.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 20)
        okButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        okButton.addTarget(self, action: #selector(onOkButtonTap), for: .touchUpInside)
        okButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(26)
            make.centerX.equalTo(contentView)
            make.height.equalTo(30)
        }
    }
}
