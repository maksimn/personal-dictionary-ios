//
//  EditorBuilder.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.01.2022.
//

protocol EditorBuilder {

    func build(initTodoItem: TodoItem?) -> UIViewController
}
