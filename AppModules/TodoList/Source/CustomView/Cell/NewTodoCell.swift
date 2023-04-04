//
//  NewTodoCell.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 18.06.2021.
//

import UIKit

class NewTodoCell: UITableViewCell {

    let placeholderLabel = UILabel()
    let textView = UITextView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(placeholderText: String, theme: Theme) {
        self.placeholderLabel.text = placeholderText
        backgroundColor = theme.cellColor
        textView.font = theme.normalFont
        placeholderLabel.textColor = theme.secondaryTextColor
        placeholderLabel.font = theme.normalFont
    }
}
