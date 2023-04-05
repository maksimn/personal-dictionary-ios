//
//  Theme.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 17.06.2021.
//

import UIKit

public protocol TodoListBuilder {

    func build() -> UIViewController
}

public final class TodoListBuilderImpl: TodoListBuilder {

    public init() { }

    public func build() -> UIViewController {
        let viewController = UIViewController()

        viewController.view.backgroundColor = .red

        _ = Theme.data

        return viewController
    }
}
