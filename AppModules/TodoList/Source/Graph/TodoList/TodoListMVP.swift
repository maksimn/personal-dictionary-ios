//
//  TodoListMVP.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 15.07.2021.
//

import UIKit

protocol TodoListMVP: AnyObject {

    var viewController: UIViewController? { get }

    func buildTodoEditorMVP(_ todoItem: TodoItem?) -> TodoEditorMVP
}
