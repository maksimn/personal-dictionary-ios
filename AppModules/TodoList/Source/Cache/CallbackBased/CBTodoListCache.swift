//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

protocol CBTodoListCache {

    var todos: [Todo] { get throws }

    var dirtyTodos: [Todo] { get throws }

    var isDirty: Bool { get }

    func insert(_ todo: Todo, _ completion: @escaping VoidCallback)

    func update(_ todo: Todo, _ completion: @escaping VoidCallback)

    func delete(_ todo: Todo, _ completion: @escaping VoidCallback)

    func replaceWith(_ todoList: [Todo], _ completion: @escaping VoidCallback)
}
