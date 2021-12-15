//
//  TodoListViewController.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 15.12.2021.
//

import UIKit

class TodoListViewController: UIViewController {

    private let label = UILabel()

    private let superAppRoutingButton = UIButton()
    private let superAppRoutingButtonTitle: String

    init(superAppRoutingButtonTitle: String) {
        self.superAppRoutingButtonTitle = superAppRoutingButtonTitle
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
        label.text = "Здесь будет Тудулист"
        view.addSubview(label)
        label.snp.makeConstraints { make -> Void in
            make.center.equalTo(view.center)
        }
    }

    func initRoutingButton() {
        superAppRoutingButton.setTitle(superAppRoutingButtonTitle, for: .normal)
        superAppRoutingButton.setTitleColor(.white, for: .normal)
        superAppRoutingButton.backgroundColor = .darkGray
        superAppRoutingButton.layer.cornerRadius = 8
        superAppRoutingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        superAppRoutingButton.addTarget(self, action: #selector(onSuperAppRoutingButtonTap), for: .touchUpInside)
        view.addSubview(superAppRoutingButton)
        superAppRoutingButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp.bottom)
            make.right.equalTo(view.snp.right)
        }
    }

    @objc
    func onSuperAppRoutingButtonTap() {
        dismiss(animated: true, completion: nil)
    }
}
