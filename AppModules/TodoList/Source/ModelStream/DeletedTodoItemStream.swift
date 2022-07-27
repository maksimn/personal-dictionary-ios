//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift

protocol DeletedTodoItemPublisher {

    func send(_ todoItem: TodoItem)
}

protocol DeletedTodoItemSubscriber {

    var deletedTodoItem: Observable<TodoItem> { get }
}
