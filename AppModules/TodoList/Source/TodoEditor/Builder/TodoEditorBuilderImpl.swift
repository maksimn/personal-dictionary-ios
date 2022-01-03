//
//  TodoEditorBuilderImpl.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.01.2022.
//

final class TodoEditorBuilderImpl: TodoEditorBuilder {

    private let service: TodoListService
    private let appViewParams: AppViewParams

    init(service: TodoListService,
         appViewParams: AppViewParams) {
        self.service = service
        self.appViewParams = appViewParams
    }

    func build(initTodoItem: TodoItem?) -> TodoEditorVIPER {
        let dependencies = TodoEditorDependencies(service: service, appViewParams: appViewParams)

        return TodoEditorVIPERImpl(todoItem: initTodoItem,
                                   service: service,
                                   viewParams: dependencies.viewParams,
                                   networkIndicatorBuilder: dependencies.networkIndicatorBuilder)
    }
}
