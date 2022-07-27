//
//  DeletedTodoItemStreamImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa
import RxSwift

final class DeletedTodoItemStreamImp: DeletedTodoItemStream {

    private let publishRelay = PublishRelay<TodoItem>()

    private init() {}

    static let instance = DeletedTodoItemStreamImp()

    func send(_ todoItem: TodoItem) {
        publishRelay.accept(todoItem)
    }

    var deletedTodoItem: Observable<TodoItem> {
        publishRelay.asObservable()
    }
}
