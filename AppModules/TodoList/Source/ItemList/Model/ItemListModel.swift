//
//  ItemListModel.swift
//  TodoList
//
//  Created by Maxim Ivanov on 05.10.2021.
//

protocol ItemListDelegate: AnyObject {

    func shouldCreate(todoItem: TodoItem)

    func shouldUpdate(data: UpdatedTodoItemData, index: Int)

    func shouldDelete(todoItem: TodoItem, index: Int)
}

protocol ItemListModel: AnyObject {

    var items: [TodoItem] { get set }

    func add(_ todoItem: TodoItem)

    func toggleCompletionForTodo(at position: Int)

    func remove(at position: Int)
}
