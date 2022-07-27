//
//  UpdatedTodoItemStreamImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift

final class UpdatedTodoItemStreamImp: UpdatedTodoItemPublisher, UpdatedTodoItemSubscriber {

    func send(_ data: UpdatedTodoItemData) {
        fatalError()
    }

    var updatedTodoItemData: Observable<UpdatedTodoItemData> {
        fatalError()
    }
}
