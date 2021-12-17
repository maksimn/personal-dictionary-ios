//
//  TodoListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 15.12.2021.
//

import CoreModule
import UIKit

class TodoListViewController: UIViewController {

    private let label = UILabel()

    private let routingButton = UIButton()
    private let routingButtonTitle: String

    init(routingButtonTitle: String, coreRouter: CoreRouter? = nil) {
        self.routingButtonTitle = routingButtonTitle
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .cyan
        initLabel()
        initRoutingButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initLabel() {
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "TodoList in progress..."
        view.addSubview(label)
        label.snp.makeConstraints { make -> Void in
            make.center.equalTo(view.center)
        }
    }

    func initRoutingButton() {
        routingButton.setTitle(routingButtonTitle, for: .normal)
        routingButton.setTitleColor(.white, for: .normal)
        routingButton.backgroundColor = .darkGray
        routingButton.layer.cornerRadius = 8
        routingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        routingButton.addTarget(self, action: #selector(onRoutingButtonTap), for: .touchUpInside)
        view.addSubview(routingButton)
        routingButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.right.equalTo(view.snp.right)
        }
    }

    @objc
    func onRoutingButtonTap() {
        dismiss(animated: true, completion: nil)
    }
}
