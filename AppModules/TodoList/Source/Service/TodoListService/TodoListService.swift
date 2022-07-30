//
//  TodoItemRemotingService.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 13.07.2021.
//

protocol TodoListService {

    var cachedTodoList: [TodoItem] { get }

    func fetchRemoteTodoList(_ completion: @escaping (Error?) -> Void)

    func createRemote(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void)

    func updateRemote(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void)

    func removeRemote(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void)

    func mergeWithRemote(_ completion: @escaping (Error?) -> Void)
}
