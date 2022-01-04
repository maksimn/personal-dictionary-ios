//
//  TodoDetailsModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

protocol TodoEditorInteractor {

    var presenter: TodoEditorPresenter? { get set }

    var todoItem: TodoItem? { get }

    func save(_ data: TodoEditorUserInput)

    func removeTodoItem()
}
