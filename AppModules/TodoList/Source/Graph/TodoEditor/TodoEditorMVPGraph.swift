//
//  TodoEditorMVP.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 14.07.2021.
//

/// DI Container для экрана редактирования todo item'a.
final class TodoEditorMVPGraph: TodoEditorMVP {

    private let view: TodoEditorView

    init(_ todoItem: TodoItem?, _ service: TodoListService) {
        let networkIndicatorBuilder = NetworkIndicatorBuilderImpl(service: service)

        var model: TodoEditorModel = TodoEditorModelOne(todoItem, service)
        view = TodoEditorViewOne(networkIndicatorBuilder: networkIndicatorBuilder)
        let presenter = TodoEditorPresenterOne(model: model, view: view)

        view.presenter = presenter
        model.presenter = presenter
    }

    var viewController: UIViewController? {
        view.viewController
    }
}
