//
//  RichTodoListModel.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

struct RichTodoListState {

    var items: [TodoItem]
    
    var areCompletedTodosVisible: Bool

    var completedItemCount: Int
}

protocol RichTodoListModel: AnyObject {

    var state: RichTodoListState { get }

    func load()

    func toggleCompletedTodoVisibility()
}
