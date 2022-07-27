//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift

struct UpdatedTodoItemData {
    let newValue: TodoItem
    let oldValue: TodoItem
}

protocol UpdatedTodoItemPublisher {

    func send(_ data: UpdatedTodoItemData)
}

protocol UpdatedTodoItemSubscriber {

    var updatedTodoItemData: Observable<UpdatedTodoItemData> { get }
}
