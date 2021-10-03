//
//  NewWordViewVC+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

extension NewWordViewVC {

    func initViews() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        addSubviews()
        initContentView()
        initSourceLangLabel()
        initTargetLangLabel()
        initArrowLabel()
        initTextField()
        initOkButton()
        initLangPickerPopup()
    }

    private func addSubviews() {
        view.addSubview(contentView)
        view.addSubview(sourceLangLabel)
        view.addSubview(targetLangLabel)
        view.addSubview(arrowLabel)
        view.addSubview(textField)
        view.addSubview(okButton)
        view.addSubview(langPickerPopup)
    }

    private func initContentView() {
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = Colors.backgroundLightColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            contentView.heightAnchor.constraint(equalToConstant: 176)
        ])
    }

    private func initSourceLangLabel() {
        sourceLangLabel.isUserInteractionEnabled = true
        sourceLangLabel.textColor = .black
        sourceLangLabel.font = UIFont.systemFont(ofSize: 17)
        sourceLangLabel.numberOfLines = 1
        sourceLangLabel.textAlignment = .right
        sourceLangLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sourceLangLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            sourceLangLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sourceLangLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -20),
            sourceLangLabel.heightAnchor.constraint(equalToConstant: 24)
        ])

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(onSourceLangLabelTap))

        tapGestureRecognizer.numberOfTapsRequired = 1
        sourceLangLabel.addGestureRecognizer(tapGestureRecognizer)
    }

    private func initTargetLangLabel() {
        targetLangLabel.isUserInteractionEnabled = true
        targetLangLabel.textColor = .black
        targetLangLabel.font = UIFont.systemFont(ofSize: 17)
        targetLangLabel.numberOfLines = 1
        targetLangLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            targetLangLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            targetLangLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 20),
            targetLangLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            targetLangLabel.heightAnchor.constraint(equalToConstant: 24)
        ])

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(onTargetLangLabelTap))

        tapGestureRecognizer.numberOfTapsRequired = 1
        targetLangLabel.addGestureRecognizer(tapGestureRecognizer)
    }

    private func initArrowLabel() {
        arrowLabel.isUserInteractionEnabled = false
        arrowLabel.textColor = .black
        arrowLabel.font = UIFont.systemFont(ofSize: 17)
        arrowLabel.numberOfLines = 1
        arrowLabel.textAlignment = .center
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.text = "⇋"
        NSLayoutConstraint.activate([
            arrowLabel.centerYAnchor.constraint(equalTo: sourceLangLabel.centerYAnchor),
            arrowLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    private func initTextField() {
        textField.placeholder = "Впишите новое слово"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.backgroundColor = UIColor.white
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 62),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func initOkButton() {
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = .green
        okButton.layer.cornerRadius = 8
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 20)
        okButton.addTarget(self, action: #selector(onOkButtonTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            okButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 26),
            okButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            okButton.widthAnchor.constraint(equalToConstant: 52),
            okButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func initLangPickerPopup() {
        langPickerPopup.onSelectLang = onSelectLang
        langPickerPopup.backgroundColor = Colors.backgroundLightColor
        langPickerPopup.layer.cornerRadius = 16
        langPickerPopup.isHidden = true
        langPickerPopup.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            langPickerPopup.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            langPickerPopup.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            langPickerPopup.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            langPickerPopup.heightAnchor.constraint(equalToConstant: 176)
        ])
    }
}
