//
//  TodoListController.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

// Technical debt.
// The code needs to be refactored.
protocol TodoListPresenter: AnyObject {

    func viewUpdateDataInList()

    func viewAddNewTodoItem()

    func viewUpdateTodoItemAt(_ position: Int)

    func viewRemoveTodoItemAt(_ position: Int)

    func viewExpandCompletedTodos()

    func viewHideCompletedTodos()

    func viewSetToggleTitle(for areCompletedTodoVisible: Bool)

    func viewUpdateActivityIndicator()

    func viewUpdate()

    func loadTodoList()

    func toggleCompletedTodoVisibility()

    func add(_ todoItem: TodoItem)

    func remove(_ todoItem: TodoItem, _ position: Int)

    func toggleCompletionForTodoAt(_ position: Int)

    func navigateToEditor(_ todoItem: TodoItem?)
}
