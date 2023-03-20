//
//  UIViewController+WordList.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.11.2022.
//

@nonobjc
extension UIViewController {

    func layout(wordListViewController: UIViewController, topOffset: CGFloat) {
        add(childViewController: wordListViewController)

        wordListViewController.view.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topOffset)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func layout(wordListView: UIView) {
        view.addSubview(wordListView)
        wordListView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view)
        }
    }
}
