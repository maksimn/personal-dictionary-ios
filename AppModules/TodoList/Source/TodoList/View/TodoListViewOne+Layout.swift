//
//  TodoListViewOne+Layout.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

extension TodoListViewOne {

    func initViews() {
        view.backgroundColor = Colors.backgroundLightColor
        addSubviews()
        initCompletedTodoVisibilityToggle()
        initCompletedTodoCountLabel()
        initTableView()
        initNewTodoItemButton()
        setConstraints()

        let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))

        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)

        initRoutingButton()
        addNetworkIndicator()
    }

    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(completedTodoVisibilityToggle)
        view.addSubview(completedTodoCountLabel)
        view.addSubview(newTodoItemButton)
    }

    func setConstraints() {
        completedTodoVisibilityToggle.constraints((view.safeAreaLayoutGuide.topAnchor, 16), 20, (nil, 0),
                                                  (view.safeAreaLayoutGuide.trailingAnchor, -32))
        completedTodoCountLabel.constraints((view.safeAreaLayoutGuide.topAnchor, 16), 20,
                                            (view.safeAreaLayoutGuide.leadingAnchor, 32), (nil, 0))
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                      constant: 0)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableViewBottomConstraint ?? NSLayoutConstraint()
        ])
        NSLayoutConstraint.activate([
            newTodoItemButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            newTodoItemButton.heightAnchor.constraint(equalToConstant: 44),
            newTodoItemButton.widthAnchor.constraint(equalToConstant: 44),
            newTodoItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        if let imageView = newTodoItemButton.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: newTodoItemButton.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: newTodoItemButton.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: newTodoItemButton.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: newTodoItemButton.bottomAnchor)
            ])
        }
    }

    func initCompletedTodoVisibilityToggle() {
        completedTodoVisibilityToggle.addTarget(self, action: #selector(onCompletedTodosVisibilityButtonTap),
                                                for: .touchUpInside)
        completedTodoVisibilityToggle.backgroundColor = .clear
        completedTodoVisibilityToggle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        completedTodoVisibilityToggle.setTitle(Strings.show, for: .normal)
        completedTodoVisibilityToggle.setTitleColor(.systemGray, for: .normal)
    }

    func initCompletedTodoCountLabel() {
        completedTodoCountLabel.textColor = .gray
        completedTodoCountLabel.font = UIFont.systemFont(ofSize: 16)
        completedTodoCountLabel.numberOfLines = 1
        completedTodoCountLabel.isUserInteractionEnabled = false
    }

    func initTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Colors.backgroundLightColor
        tableView.layer.cornerRadius = 16
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: "\(TodoItemCell.self)")
        tableView.register(NewTodoItemCell.self, forCellReuseIdentifier: "\(NewTodoItemCell.self)")
        tableView.dataSource = tableController
        tableView.backgroundColor = Colors.backgroundLightColor
        tableView.delegate = tableController
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableController.onNewTodoItemTextEnter = self.onNewTodoItemTextEnter
        tableController.onDeleteTap = self.onDeleteTodoTap
        tableController.onTodoCompletionTap = self.onTodoCompletionTap
        tableController.onDidSelectAt = self.onDidSelectAt
    }

    func initNewTodoItemButton() {
        newTodoItemButton.setImage(Images.plusIcon, for: .normal)
        newTodoItemButton.imageView?.contentMode = .scaleAspectFit
        newTodoItemButton.translatesAutoresizingMaskIntoConstraints = false
        newTodoItemButton.addTarget(self, action: #selector(onNewTodoItemButtonTap), for: .touchUpInside)
    }

    func initKeyboardEventsHandle() {
        keyboardEventsHandle.registerForKeyboardNotifications()
        keyboardEventsHandle.onKeyboardWillHide = self.normalTableViewHeightWhenKeyboardHidden
        keyboardEventsHandle.onKeyboardWillShow = self.smallerTableViewHeightWhenKeyboardShown
    }

    func smallerTableViewHeightWhenKeyboardShown(_ keyboardSize: CGSize) {
        let bottomPadding = view.window?.safeAreaInsets.bottom ?? CGFloat.zero

        tableViewBottomConstraint?.constant = -keyboardSize.height - bottomPadding - (isFirstKeyboardShow ? 12 : 48)
        shouldTableViewScrollToBottom = true
        isFirstKeyboardShow = false
    }

    func normalTableViewHeightWhenKeyboardHidden(_ keyboardSize: CGSize) {
        tableViewBottomConstraint?.constant = 0
        shouldTableViewScrollToBottom = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if shouldTableViewScrollToBottom {
            shouldTableViewScrollToBottom = false
            tableView.scrollToBottom(animated: false)
        }
    }

    func initRoutingButton() {
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

    @objc
    func onRoutingButtonTap() {
        dismiss(animated: true, completion: nil)
    }

    func addNetworkIndicator() {
        let networkIndicatorVIPER = networkIndicatorBuilder.build()
        let networkIndicatorView = networkIndicatorVIPER.uiview

        view.addSubview(networkIndicatorView)
        networkIndicatorView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}

extension UITableView {

    fileprivate func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)

        if rows > 0 {
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom,
                             animated: animated)
        }
    }
}
