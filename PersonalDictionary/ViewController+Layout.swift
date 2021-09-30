//
//  ViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

extension ViewController {

    func initViews() {
        view.backgroundColor = Colors.backgroundLightColor
        initNewWordButton()
    }

    private func initNewWordButton() {
        newWordButton.setImage(Images.plusIcon, for: .normal)
        newWordButton.imageView?.contentMode = .scaleAspectFit
        newWordButton.translatesAutoresizingMaskIntoConstraints = false
        newWordButton.addTarget(self, action: #selector(onNewWordButtonTap), for: .touchUpInside)
        view.addSubview(newWordButton)
        NSLayoutConstraint.activate([
            newWordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            newWordButton.heightAnchor.constraint(equalToConstant: 44),
            newWordButton.widthAnchor.constraint(equalToConstant: 44),
            newWordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        if let imageView = newWordButton.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: newWordButton.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: newWordButton.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: newWordButton.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: newWordButton.bottomAnchor)
            ])
        }
    }
}
