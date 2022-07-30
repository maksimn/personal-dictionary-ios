//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa
import RxSwift

protocol CreatedTodoItemPublisher {

    func send(_ todoItem: TodoItem)
}

protocol CreatedTodoItemSubscriber {

    var todoItem: Observable<TodoItem> { get }
}

final class CreatedTodoItemStreamImp: CreatedTodoItemPublisher, CreatedTodoItemSubscriber {

    private let publishRelay = PublishRelay<TodoItem>()

    private init() {}

    static let instance = CreatedTodoItemStreamImp()

    func send(_ todoItem: TodoItem) {
        publishRelay.accept(todoItem)
    }

    var todoItem: Observable<TodoItem> {
        publishRelay.asObservable()
    }
}
