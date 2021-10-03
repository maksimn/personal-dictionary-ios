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
        newWordButton.addTarget(self, action: #selector(onNewWordButtonTap), for: .touchUpInside)
        view.addSubview(newWordButton)
        newWordButton.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }
        if let imageView = newWordButton.imageView {
            imageView.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(newWordButton)
            }
        }
    }
}
