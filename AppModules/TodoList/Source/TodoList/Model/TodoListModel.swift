//
//  TodoListModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 20.06.2021.
//

protocol TodoListModel {

    var presenter: TodoListPresenter? { get set }

    var todoList: [TodoItem] { get }

    var completedTodoCount: Int { get }

    var areCompletedTodosVisible: Bool { get }

    var areRequestsPending: Bool { get }

    func loadTodoListFromCache()

    func loadTodoListFromRemote(_ completion: @escaping (Error?) -> Void)

    func add(_ todoItem: TodoItem)

    func remove(_ todoItem: TodoItem, _ position: Int)

    func toggleCompletionForTodoAt(_ position: Int)

    func toggleCompletedTodoVisibility()
}
