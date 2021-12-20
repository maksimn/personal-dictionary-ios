//
//  TodoCell.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

class TodoItemCell: UITableViewCell {

    let todoTextlabel = UILabel()
    let completenessImageView = UIImageView()
    let rightArrowImageView = UIImageView()
    let priorityImageView = UIImageView()
    let deadlineImageView = UIImageView()
    let deadlineLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(todoItem: TodoItem) {
        setText(from: todoItem)
        priorityImageView.image = image(for: todoItem.priority)
        setLayout(isPriorityNormal: todoItem.priority == .normal)
        deadlineImageView.isHidden = todoItem.deadline == nil
        deadlineLabel.isHidden = deadlineImageView.isHidden
        deadlineLabel.text = todoItem.deadline?.formattedDate
        completenessImageView.image = completenessImage(for: todoItem)
    }

    private func image(for priority: TodoItemPriority) -> UIImage? {
        switch priority {
        case .high:
            priorityImageView.isHidden = false
            return Images.highPriorityMark
        case .low:
            priorityImageView.isHidden = false
            return Images.lowPriorityMark
        default:
            priorityImageView.isHidden = true
            return nil
        }
    }

    private func completenessImage(for todoItem: TodoItem) -> UIImage? {
        if todoItem.isCompleted {
            return Images.completedTodoMark
        } else if todoItem.priority == .high {
            return Images.highPriorityTodoMark
        } else {
            return Images.incompletedTodoMark
        }
    }

    private func setText(from todoItem: TodoItem) {
        let attributes = todoItem.isCompleted ?
            [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue] : nil
        let attrString = NSAttributedString(string: todoItem.text, attributes: attributes)

        todoTextlabel.attributedText = attrString
        todoTextlabel.textColor = todoItem.isCompleted ? Colors.labelLightTextColor : .black
    }
}
