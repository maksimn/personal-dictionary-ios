//
//  TodoCell.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

struct TodoCellImage {
    let highPriorityIcon: UIImage
    let lowPriorityIcon: UIImage
    let completedCircle: UIImage
    let highPriorityCircle: UIImage
    let incompleteCircle: UIImage
    let rightArrow: UIImage
    let smallCalendar: UIImage
}

class TodoCell: UITableViewCell {

    let textlabel = UILabel()
    let leadingImageView = UIImageView()
    let trailingImageView = UIImageView()
    let priorityImageView = UIImageView()
    let calendarIconView = UIImageView()
    let deadlineLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(todo: Todo, theme: Theme, cellImage: TodoCellImage) {
        backgroundColor = theme.cellColor
        textlabel.textColor = theme.textColor
        textlabel.font = theme.normalFont
        setText(from: todo, theme: theme)
        trailingImageView.image = cellImage.rightArrow
        calendarIconView.image = cellImage.smallCalendar
        deadlineLabel.textColor = theme.secondaryTextColor

        priorityImageView.image = image(for: todo.priority, cellImage: cellImage)
        calendarIconView.isHidden = todo.deadline == nil
        deadlineLabel.isHidden = calendarIconView.isHidden
        deadlineLabel.text = todo.deadline?.dMMMMyyyy
        leadingImageView.image = completenessImage(for: todo, cellImage: cellImage)
        updateLayout(isPriorityHidden: todo.priority == .normal, isDeadlineHidden: todo.deadline == nil)
    }

    private func image(for priority: TodoPriority, cellImage: TodoCellImage) -> UIImage? {
        switch priority {
        case .high:
            priorityImageView.isHidden = false
            return cellImage.highPriorityIcon
        case .low:
            priorityImageView.isHidden = false
            return cellImage.lowPriorityIcon
        default:
            priorityImageView.isHidden = true
            return nil
        }
    }

    private func completenessImage(for todo: Todo, cellImage: TodoCellImage) -> UIImage? {
        if todo.isCompleted {
            return cellImage.completedCircle
        } else if todo.priority == .high {
            return cellImage.highPriorityCircle
        } else {
            return cellImage.incompleteCircle
        }
    }

    private func setText(from todo: Todo, theme: Theme) {
        let attributes = todo.isCompleted ?
            [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue] : nil

        textlabel.attributedText = NSAttributedString(string: todo.text, attributes: attributes)
        textlabel.textColor = todo.isCompleted ? theme.secondaryTextColor : theme.textColor
    }
}
