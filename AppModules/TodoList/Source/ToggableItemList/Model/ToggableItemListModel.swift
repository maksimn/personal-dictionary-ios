//
//  ToggableItemListModel.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

struct ToggableItemListState {

    var items: [TodoItem]
    
    var areCompletedTodosVisible: Bool

    var completedItemCount: Int
}

protocol ToggableItemListModel: AnyObject {

    var state: ToggableItemListState { get }

    func load()

    func toggleCompletedTodoVisibility()
}
