//
//  UIViewController+WordList.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2022.
//

extension UIViewController {

    func layout(wordListViewController: UIViewController, topOffset: CGFloat = 46) {
        view.addSubview(wordListViewController.view)
        addChild(wordListViewController)
        wordListViewController.didMove(toParent: self)
        wordListViewController.view.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topOffset)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
