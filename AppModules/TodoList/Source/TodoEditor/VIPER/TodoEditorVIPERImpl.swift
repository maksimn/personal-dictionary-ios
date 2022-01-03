//
//  TodoEditorMVP.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 14.07.2021.
//

/// DI Container для экрана редактирования todo item'a.
final class TodoEditorVIPERImpl: TodoEditorVIPER {

    private let view: TodoEditorViewController

    init(todoItem: TodoItem?,
         service: TodoListService,
         viewParams: TodoEditorViewParams,
         networkIndicatorBuilder: NetworkIndicatorBuilder) {
        var model: TodoEditorInteractor = TodoEditorInteractorImpl(todoItem, service)
        view = TodoEditorViewController(params: viewParams,
                                        networkIndicatorBuilder: networkIndicatorBuilder)
        let presenter = TodoEditorPresenterImpl(model: model, view: view)

        view.presenter = presenter
        model.presenter = presenter
    }

    var viewController: UIViewController {
        view
    }
}
