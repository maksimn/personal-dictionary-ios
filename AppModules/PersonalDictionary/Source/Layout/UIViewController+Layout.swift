//
//  UIViewController+WordList.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2022.
//

import UIKit

@nonobjc
extension UIViewController {

    func layout(childViewController: UIViewController, topOffset: CGFloat = 0) {
        add(childViewController: childViewController)
        childViewController.view.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topOffset)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func layout(wordListView: UIView, topOffset: CGFloat = 0) {
        view.addSubview(wordListView)
        wordListView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topOffset)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func layout(centerLabel: UILabel) {
        view.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(view).offset(-20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
}
