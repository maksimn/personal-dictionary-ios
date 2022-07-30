//
//  RichTodoListView+Layout.swift
//  TodoList
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import UIKit

extension RichTodoListView {

    func initViews() {
        initCompletedTodoVisibilityToggle()
        initItemListView()
        initCounterView()
    }

    private func initCompletedTodoVisibilityToggle() {
        addSubview(completedTodoVisibilityToggle)
        completedTodoVisibilityToggle.addTarget(self, action: #selector(onCompletedTodosVisibilityButtonTap),
                                                for: .touchUpInside)
        completedTodoVisibilityToggle.backgroundColor = .clear
        completedTodoVisibilityToggle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        completedTodoVisibilityToggle.setTitle(Strings.show, for: .normal)
        completedTodoVisibilityToggle.setTitleColor(.systemGray, for: .normal)
        completedTodoVisibilityToggle.constraints((topAnchor, 16), 20, (nil, 0), (trailingAnchor, -32))
    }

    private func initItemListView() {
        let itemListGraphView = itemListGraph.view

        addSubview(itemListGraphView)
        itemListGraphView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemListGraphView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            itemListGraphView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            itemListGraphView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            itemListGraphView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func initCounterView() {
        let counterView = counterGraph.view

        addSubview(counterView)
        counterView.constraints((self.topAnchor, 16), 20, (self.leadingAnchor, 32), (nil, 0))
    }
}
