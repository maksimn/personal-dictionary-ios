//
//  TodoEditorViewParams.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.01.2022.
//

import UIKit

struct TodoEditorViewParams {

    let backgroundLightColor: UIColor
    let prioritySegmentedControlItems: [Any]
    let newTodoPlaceholder: String
    let priority: String
    let shouldBeDoneBefore: String
    let remove: String
    let navBar: TodoEditorNavBarParams
}
