//
//  NewWordViewVC+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

extension NewWordViewVC {

    func initViews() {
        view.backgroundColor = Colors.backgroundLightColor
        addSubviews()
        initSourceLangLabel()
        initTargetLangLabel()
        initLangPickerView()
        initArrowLabel()
        initTextField()
    }

    private func addSubviews() {
        view.addSubview(sourceLangLabel)
        view.addSubview(targetLangLabel)
        view.addSubview(langPickerView)
        view.addSubview(arrowLabel)
        view.addSubview(textField)
    }

    private func initSourceLangLabel() {
        sourceLangLabel.isUserInteractionEnabled = true
        sourceLangLabel.textColor = .black
        sourceLangLabel.font = UIFont.systemFont(ofSize: 17)
        sourceLangLabel.numberOfLines = 1
        sourceLangLabel.textAlignment = .right
        sourceLangLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sourceLangLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            sourceLangLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            sourceLangLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -22),
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
            targetLangLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            targetLangLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 22),
            targetLangLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            targetLangLabel.heightAnchor.constraint(equalToConstant: 24)
        ])

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(onTargetLangLabelTap))

        tapGestureRecognizer.numberOfTapsRequired = 1
        targetLangLabel.addGestureRecognizer(tapGestureRecognizer)
    }

    private func initLangPickerView() {
        langPickerView.isHidden = true
        langPickerView.dataSource = langPickerController
        langPickerView.delegate = langPickerController
        langPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            langPickerView.topAnchor.constraint(equalTo: sourceLangLabel.bottomAnchor, constant: 6),
            langPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            langPickerView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            langPickerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])

        langPickerController.onSelectRow = onSelectPicker(row:)
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
            arrowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func initTextField() {
        textField.placeholder = "Впишите новое слово"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.backgroundColor = UIColor.white
        textField.textColor = .black
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.center = view.center
    }
}