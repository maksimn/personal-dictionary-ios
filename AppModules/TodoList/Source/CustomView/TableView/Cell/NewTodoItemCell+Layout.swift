//
//  NewTodoItemCell+Layout.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 19.06.2021.
//

import UIKit

extension NewTodoItemCell {

    static let cellHeight: CGFloat = 54

    func initViews() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        selectionStyle = .none
        backgroundColor = .white
        initPlacholderLabel()
        initTextView()
    }

    private func initTextView() {
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 18, bottom: 16, right: 20)
        textView.contentOffset = CGPoint(x: 0, y: -6)
        addSubview(textView)
        textView.constraints((topAnchor, 16), 24, (leadingAnchor, 16), (trailingAnchor, -16))
        textView.backgroundColor = .clear
        textView.layer.cornerRadius = 16
        textView.isEditable = true
    }

    private func initPlacholderLabel() {
        placeholderLabel.textColor = .gray
        placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.text = "Новое"
        contentView.addSubview(placeholderLabel)
        placeholderLabel.constraints((topAnchor, 17), 24, (leadingAnchor, 40), (trailingAnchor, -20))
        placeholderLabel.isUserInteractionEnabled = false
    }
}
