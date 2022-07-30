//
//  RichTodoListGraph.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import UIKit

protocol RichTodoListGraph {

    var view: UIView { get }

    var model: RichTodoListModel? { get }
}
