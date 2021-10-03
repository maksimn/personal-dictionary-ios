//
//  LangPickerPopup+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 03.10.2021.
//

import UIKit

extension LangPickerPopup {

    func initViews() {
        addSubview(pickerView)
        addSubview(selectButton)
        initLangPickerView()
        initSelectButton()
    }

    private func initLangPickerView() {
        pickerView.dataSource = langPickerController
        pickerView.delegate = langPickerController
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44)
        ])
    }

    private func initSelectButton() {
        selectButton.setTitle("Выбрать", for: .normal)
        selectButton.setTitleColor(.white, for: .normal)
        selectButton.backgroundColor = .darkGray
        selectButton.layer.cornerRadius = 8
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.addTarget(self, action: #selector(onSelectButtonTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            selectButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            selectButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            selectButton.widthAnchor.constraint(equalToConstant: 86),
            selectButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
