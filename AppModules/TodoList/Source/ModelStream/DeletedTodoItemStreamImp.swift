//
//  DeletedTodoItemStreamImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift

final class DeletedTodoItemStreamImp: DeletedTodoItemPublisher, DeletedTodoItemSubscriber {

    func send(_ todoItem: TodoItem) {
        fatalError()
    }

    var deletedTodoItem: Observable<TodoItem> {
        fatalError()
    }
}
