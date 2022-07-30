//
//  TodoItemCell+Layout.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 18.06.2021.
//

import UIKit

extension TodoItemCell {

    static var fulfillmentMarginLeft: CGFloat { 16 }
    static var fulfillmentWidth: CGFloat { 24 }
    static var textMarginLeft: CGFloat { 12 }
    static var textMarginRight: CGFloat { 35 }
    static var priorityImageWidth: CGFloat { 10 }
    static var priorityImageVisibleMargin: CGFloat { 16 }
    static var deadlineHeight: CGFloat { 18.5 }
    static var font: UIFont { UIFont.systemFont(ofSize: CGFloat(17), weight: .regular) }

    func initViews() {
        selectionStyle = .none
        backgroundColor = .white
        todoTextlabel.textColor = .black
        todoTextlabel.font = TodoItemCell.font
        todoTextlabel.backgroundColor = .clear
        todoTextlabel.numberOfLines = 3
        contentView.addSubview(todoTextlabel)

        contentView.addSubview(completenessImageView)
        contentView.addSubview(priorityImageView)

        rightArrowImageView.image = Theme.image.rightArrowMark
        contentView.addSubview(rightArrowImageView)

        deadlineImageView.image = Theme.image.smallCalendarIcon
        contentView.addSubview(deadlineImageView)

        deadlineLabel.textColor = Theme.data.lightTextColor
        deadlineLabel.font = UIFont.systemFont(ofSize: 15)
        addSubview(deadlineLabel)
    }

    static func height(for text: String, cellWidth: CGFloat, priority: TodoItemPriority,
                       showDeadline: Bool) -> CGFloat {
        let lineHeight: CGFloat = 20.28711
        let numLines = countNumberOfLines(for: text, cellWidth: cellWidth, priority: priority)

        return lineHeight * CGFloat(numLines) + 32 + (showDeadline ? TodoItemCell.deadlineHeight : 0)
    }

    func setLayout(isPriorityNormal: Bool) {
        completenessImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completenessImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            completenessImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                           constant: TodoItemCell.fulfillmentMarginLeft),
            completenessImageView.heightAnchor.constraint(equalToConstant: 24),
            completenessImageView.widthAnchor.constraint(equalToConstant: TodoItemCell.fulfillmentWidth)
        ])

        priorityImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priorityImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            priorityImageView.heightAnchor.constraint(equalToConstant: 16),
            priorityImageView.widthAnchor.constraint(equalToConstant: isPriorityNormal ? 0 :
                                                                                       TodoItemCell.priorityImageWidth),
            priorityImageView.leadingAnchor.constraint(equalTo: completenessImageView.trailingAnchor, constant: 12)
        ])

        todoTextlabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todoTextlabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            todoTextlabel.leadingAnchor.constraint(equalTo: completenessImageView.trailingAnchor,
                constant: isPriorityNormal ? TodoItemCell.textMarginLeft :
                                             TodoItemCell.textMarginLeft + TodoItemCell.priorityImageVisibleMargin),
            todoTextlabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -TodoItemCell.textMarginRight)
        ])

        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightArrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightArrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightArrowImageView.heightAnchor.constraint(equalToConstant: 12),
            rightArrowImageView.widthAnchor.constraint(equalToConstant: 7)
        ])

        deadlineImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deadlineImageView.leadingAnchor.constraint(equalTo: todoTextlabel.leadingAnchor, constant: 0),
            deadlineImageView.widthAnchor.constraint(equalToConstant: 13),
            deadlineImageView.heightAnchor.constraint(equalToConstant: 12),
            deadlineImageView.topAnchor.constraint(equalTo: todoTextlabel.bottomAnchor, constant: 6)
        ])

        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deadlineLabel.leadingAnchor.constraint(equalTo: deadlineImageView.trailingAnchor, constant: 5),
            deadlineLabel.topAnchor.constraint(equalTo: deadlineImageView.topAnchor, constant: -2.5),
            deadlineLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    static func countNumberOfLines(for text: String, cellWidth: CGFloat, priority: TodoItemPriority) -> Int {
        let maxNumLines = 3
        let paragraphs = text.components(separatedBy: "\n").prefix(maxNumLines)
        let delta: CGFloat = 40
        let marginWhenPriorityImageVisible: CGFloat = priority == .normal ? 0 : TodoItemCell.priorityImageVisibleMargin
        let labelWidth: CGFloat = cellWidth - (TodoItemCell.fulfillmentMarginLeft + TodoItemCell.fulfillmentWidth +
            marginWhenPriorityImageVisible + TodoItemCell.textMarginLeft + TodoItemCell.textMarginRight) - delta
        let paragraphLines: [Int] = paragraphs.map { Int(ceil(widthOfText($0, font) / labelWidth)) }
        let numLines = paragraphLines.reduce(0, +)
        let result = min(maxNumLines, numLines)

        return result > 0 ? result : 1
    }

    private static func widthOfText(_ text: String, _ font: UIFont) -> CGFloat {
        (text as NSString).size(withAttributes: [NSAttributedString.Key.font: font]).width
    }
}
