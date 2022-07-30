//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa
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

final class UpdatedTodoItemStreamImp: UpdatedTodoItemPublisher, UpdatedTodoItemSubscriber {

    private let publishRelay = PublishRelay<UpdatedTodoItemData>()

    private init() {}

    static let instance = UpdatedTodoItemStreamImp()

    func send(_ data: UpdatedTodoItemData) {
        publishRelay.accept(data)
    }

    var updatedTodoItemData: Observable<UpdatedTodoItemData> {
        publishRelay.asObservable()
    }
}
