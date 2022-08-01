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
    static var priorityImageMargin: CGFloat { 16 }
    static var deadlineHeight: CGFloat { 18.5 }
    static var font: UIFont { UIFont.systemFont(ofSize: CGFloat(17), weight: .regular) }

    func initViews() {
        selectionStyle = .none
        backgroundColor = .white
        textlabel.textColor = .black
        textlabel.font = TodoItemCell.font
        textlabel.backgroundColor = .clear
        textlabel.numberOfLines = 3
        contentView.addSubview(textlabel)

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

    override func layoutSubviews() {
        super.layoutSubviews()
        let priorityImageWidth: CGFloat = todoItem?.priority == .normal ? 0 : TodoItemCell.priorityImageMargin
        let textLabelLeftMargin = TodoItemCell.fulfillmentMarginLeft + TodoItemCell.fulfillmentWidth +
            priorityImageWidth + TodoItemCell.textMarginLeft + 2.5

        textlabel.preferredMaxLayoutWidth = frame.width - (textLabelLeftMargin + TodoItemCell.textMarginRight)
        textlabel.frame = CGRect(origin: CGPoint(x: textLabelLeftMargin, y: 17),
                                 size: textlabel.intrinsicContentSize)
    }

    var computedHeight: CGFloat {
        textlabel.frame.height + 34 + (todoItem?.deadline != nil ? TodoItemCell.deadlineHeight : 0)
    }

    func setLayout() {
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
            priorityImageView.widthAnchor.constraint(equalToConstant: TodoItemCell.priorityImageWidth),
            priorityImageView.leadingAnchor.constraint(equalTo: completenessImageView.trailingAnchor, constant: 12)
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
            deadlineImageView.leadingAnchor.constraint(equalTo: textlabel.leadingAnchor),
            deadlineImageView.widthAnchor.constraint(equalToConstant: 13),
            deadlineImageView.heightAnchor.constraint(equalToConstant: 12),
            deadlineImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deadlineLabel.leadingAnchor.constraint(equalTo: deadlineImageView.trailingAnchor, constant: 5),
            deadlineLabel.topAnchor.constraint(equalTo: deadlineImageView.topAnchor, constant: -2.5),
            deadlineLabel.heightAnchor.constraint(equalToConstant: TodoItemCell.deadlineHeight)
        ])
    }
}
