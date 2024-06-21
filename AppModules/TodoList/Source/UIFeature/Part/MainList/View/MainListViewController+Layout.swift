//
//  MainListLayout.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 07.02.2023.
//

import UIKit

extension MainListViewController {

    func setTableViewLayout(for keyboardState: KeyboardUDF.State) {
        let tableViewFrame = CGRect(x: .zero, y: .zero, width: view.bounds.width, height: view.bounds.height)
        let smallerFrameSize = CGSize(
            width: tableViewFrame.width,
            height: tableViewFrame.height - keyboardState.size.height - 12
        )
        let smallerFrame = CGRect(origin: .zero, size: smallerFrameSize)

        tableView.frame = keyboardState.isVisible ? smallerFrame : tableViewFrame
    }

    func initViews() {
        initTableView()
        initNavigationButton()
        initKeyboardController()
    }

    private func initTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = theme.backgroundColor
        tableView.layer.cornerRadius = 16
        tableView.register(TodoCell.self, forCellReuseIdentifier: "\(TodoCell.self)")
        tableView.register(NewTodoCell.self, forCellReuseIdentifier: "\(NewTodoCell.self)")
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.keyboardDismissMode = .onDrag
    }

    private func initNavigationButton() {
        view.addSubview(navigationButton)
        navigationButton.setImage(params.navImage, for: .normal)
        navigationButton.imageView?.contentMode = .scaleAspectFit
        navigationButton.addTarget(self, action: #selector(navigate), for: .touchUpInside)
        navigationButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.centerX.equalTo(view)
        }
        if let imageView = navigationButton.imageView {
            imageView.snp.makeConstraints { make in
                make.edges.equalTo(navigationButton)
            }
        }
    }

    private func initKeyboardController() {
        add(childViewController: keyboardController)
        keyboardController.view.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
}
