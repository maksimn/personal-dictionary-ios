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
    }

    private func addSubviews() {
        view.addSubview(sourceLangLabel)
        view.addSubview(targetLangLabel)
    }

    private func initSourceLangLabel() {
        sourceLangLabel.textColor = .black
        sourceLangLabel.font = UIFont.systemFont(ofSize: 17)
        sourceLangLabel.numberOfLines = 1
        sourceLangLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sourceLangLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            sourceLangLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -22)
        ])
    }

    private func initTargetLangLabel() {
        targetLangLabel.textColor = .black
        targetLangLabel.font = UIFont.systemFont(ofSize: 17)
        targetLangLabel.numberOfLines = 1
        targetLangLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            targetLangLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            targetLangLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 22)
        ])
    }
}
