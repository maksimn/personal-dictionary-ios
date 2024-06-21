//
//  NewTodoCell+Layout.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 19.06.2021.
//

import SnapKit
import UIKit

extension NewTodoCell {

    func initViews() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        selectionStyle = .none
        initPlacholderLabel()
        initTextView()
    }

    private func initTextView() {
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 18, bottom: 16, right: 20)
        textView.contentOffset = CGPoint(x: 0, y: -6)
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(16)
            make.left.equalTo(self.contentView.snp.left).offset(16)
            make.right.equalTo(self.contentView.snp.right).offset(-16)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-14)
            make.height.equalTo(24)
        }
        textView.backgroundColor = .clear
        textView.layer.cornerRadius = 16
        textView.isEditable = true
    }

    private func initPlacholderLabel() {
        contentView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(17)
            make.left.equalTo(self.contentView.snp.left).offset(40)
            make.right.equalTo(self.contentView.snp.right).offset(-20)
            make.height.equalTo(24)
        }
        placeholderLabel.isUserInteractionEnabled = false
    }
}
