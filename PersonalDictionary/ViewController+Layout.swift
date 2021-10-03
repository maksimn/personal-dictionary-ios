//
//  ViewController+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

extension ViewController {

    func initViews() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        initNewWordButton()
    }

    private func initNewWordButton() {
        newWordButton.setImage(UIImage(named: "icon-plus")!, for: .normal)
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
