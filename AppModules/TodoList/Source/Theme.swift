//
//  Theme.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

struct Theme {

    let backgroundColor: UIColor

    let lightTextColor: UIColor

    let darkRed: UIColor

    let darkGreen: UIColor

    private init(backgroundColor: UIColor,
                 lightTextColor: UIColor,
                 darkRed: UIColor,
                 darkGreen: UIColor) {
        self.backgroundColor = backgroundColor
        self.lightTextColor = lightTextColor
        self.darkRed = darkRed
        self.darkGreen = darkGreen
    }

    static let data = Theme(
        backgroundColor: UIColor(red: 1.00, green: 0.80, blue: 1.00, alpha: 1.00),
        lightTextColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3),
        darkRed: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1),
        darkGreen: UIColor(red: 0.196, green: 0.843, blue: 0.294, alpha: 1)
    )

    static let image = ThemeImage()
}

class ThemeImage {

    private lazy var bundle = Bundle(for: type(of: self))

    lazy var highPriorityMark = UIImage(named: "high-priority", in: bundle, with: nil)!
    lazy var lowPriorityMark = UIImage(named: "low-priority", in: bundle, with: nil)!

    lazy var completedTodoMark = UIImage(named: "finished-todo", in: bundle, with: nil)!
    lazy var completedTodoMarkInverse = UIImage(named: "finished-todo-inverse", in: bundle, with: nil)!
    lazy var highPriorityTodoMark = UIImage(named: "high-priority-circle", in: bundle, with: nil)!
    lazy var incompletedTodoMark = UIImage(named: "not-finished-todo", in: bundle, with: nil)!

    lazy var rightArrowMark = UIImage(named: "right-arrow", in: bundle, with: nil)!

    lazy var smallCalendarIcon = UIImage(named: "small-calendar", in: bundle, with: nil)!

    lazy var trashImage = UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!
}
