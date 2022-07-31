//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

protocol TodoListCache {

    var isDirty: Bool { get }

    var items: [TodoItem] { get }

    var completedItemCount: Int { get }

    func insert(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void)

    func update(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void)

    func delete(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void)

    func replaceWith(_ todoList: [TodoItem], _ completion: @escaping (Error?) -> Void)
}
