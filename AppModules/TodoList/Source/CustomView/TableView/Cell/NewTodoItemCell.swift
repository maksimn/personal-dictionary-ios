//
//  NewTodoItemCell.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 18.06.2021.
//

import UIKit

class NewTodoItemCell: UITableViewCell {

    let placeholderLabel = UILabel()
    let textView = UITextView()

    var onNewTodoItemTextEnter: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewTodoItemCell: UITextViewDelegate {

    public func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }

        placeholderLabel.isHidden = text.count > 0

        if let enteredCharacter = text.last,
            enteredCharacter == "\n" {
            textView.resignFirstResponder()
            onNewTodoItemTextEnter?(text.trimmingCharacters(in: .whitespacesAndNewlines))
            placeholderLabel.isHidden = false
            textView.text = ""
        }
    }
}
