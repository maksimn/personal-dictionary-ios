//
//  Values.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

enum Colors {
    static let backgroundLightColor = UIColor(red: 1.00, green: 0.80, blue: 1.00, alpha: 1.00)
    static let labelLightTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)

    static let darkRed = UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1)
    static let darkGreen = UIColor(red: 0.196, green: 0.843, blue: 0.294, alpha: 1)
}

enum Strings {
    static let empty = ""

    static let newTodo = "Новое"
    static let todo = "Дело"

    static let save = "Сохранить"
    static let cancel = "Отменить"
    static let remove = "Удалить"
    static let show = "Показать"
    static let hide = "Скрыть"
    static let noPriority = "нет"

    static let newTodoPlaceholder = "Что надо сделать?"
    static let priority = "Важность"
    static let shouldBeDoneBefore = "Сделать до"

    static let completed = "Выполнено — "
    static let myTodos = "Мои дела"

    static let todoListFile = "todos.json"
}

enum Characters {
    static let lineBreak: Character = "\n"
}

final class SPPImages {
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

    lazy var plusIcon = UIImage(named: "icon-plus", in: bundle, with: nil)!
}

var Images = SPPImages()

enum WebAPI {
    static let baseUrl = "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net"
}

enum BearerToken {
    static let key = "Authorization"
    static let value = "Bearer LTQzMTQwMzg4MjU0MzEwMjgwMjE"
}

enum RequestType {
    static let getTodoList = "GET TODOLIST"
    static let createTodoItem = "CREATE TODO ITEM"
    static let updateTodoItem = "UPDATE TODO ITEM"
    static let deleteTodoItem = "DELETE TODO ITEM"
    static let mergeTodoList = "MERGE TODOLIST"
}
