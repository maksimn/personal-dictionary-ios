//
//  TodoDetailsModel.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 10.06.2021.
//

protocol EditorInteractor {

    var presenter: EditorPresenter? { get set }

    var todoItem: TodoItem? { get }

    func save(_ data: EditorUserInput)

    func removeTodoItem()
}
