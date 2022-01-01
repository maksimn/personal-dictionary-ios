//
//  TodoListMVP.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 12.07.2021.
//

import UIKit

final class TodoListMVPGraph: TodoListMVP {

    private let view: TodoListView
    private let service: TodoListService

    init(_ service: TodoListService) {
        self.service = service

        let networkIndicatorBuilder = NetworkIndicatorBuilderImpl(service: service)

        view = TodoListViewOne(networkIndicatorBuilder: networkIndicatorBuilder)
        var model: TodoListModel = TodoListModelOne(service)
        let presenter: TodoListPresenter = TodoListPresenterOne(model: model, view: view, mvp: self)

        view.presenter = presenter
        model.presenter = presenter
    }

    var viewController: UIViewController? {
        view.viewController
    }

    func buildTodoEditorMVP(_ todoItem: TodoItem?) -> TodoEditorMVP {
        TodoEditorMVPGraph(todoItem, service)
    }
}
