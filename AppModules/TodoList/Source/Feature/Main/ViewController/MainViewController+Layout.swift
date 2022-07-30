//
//  MainWordListContainer+Layout.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 08.11.2021.
//

import UIKit

extension MainViewController {

    func layout(richTodoListView: UIView) {
        view.addSubview(richTodoListView)
        richTodoListView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }

    func layout(_ navToEditorBuilder: NavToEditorBuilder) {
        let navToEditorView = navToEditorBuilder.build()

        view.addSubview(navToEditorView)
        navToEditorView.snp.makeConstraints { make -> Void in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.centerX.equalTo(view)
        }
    }

    func layout(_ networkIndicatorBuilder: NetworkIndicatorBuilder) {
        let networkIndicatorVIPER = networkIndicatorBuilder.build()
        let networkIndicatorView = networkIndicatorVIPER.uiview

        view.addSubview(networkIndicatorView)
        networkIndicatorView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            make.centerX.equalTo(view.snp.centerX)
        }
    }

    func layoutRoutingButton() {
        routingButton.setTitle("Back", for: .normal)
        routingButton.setTitleColor(.white, for: .normal)
        routingButton.backgroundColor = .darkGray
        routingButton.layer.cornerRadius = 8
        routingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        routingButton.addTarget(self, action: #selector(onRoutingButtonTap), for: .touchUpInside)
        view.addSubview(routingButton)
        routingButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-8)
        }
    }
}
