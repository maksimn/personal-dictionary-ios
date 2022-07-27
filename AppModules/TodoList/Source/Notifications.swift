//
//  Notifications.swift
//  ToDoList
//
//  Created by Max Ivanov on 22.06.2021.
//

import Foundation

extension Notification.Name {

    static let createTodoItem = Notification.Name("createTodoItem")

    static let mergeTodoListWithRemoteSuccess = Notification.Name("mergeTodoListWithRemoteSuccess")

    static let httpRequestCounterIncrement = Notification.Name("httpRequestCounterIncrement")
    static let httpRequestCounterDecrement = Notification.Name("httpRequestCounterDecrement")
}
