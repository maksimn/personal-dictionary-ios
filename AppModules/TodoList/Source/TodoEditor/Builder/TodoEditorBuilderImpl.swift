//
//  TodoEditorBuilderImpl.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.01.2022.
//

final class TodoEditorBuilderImpl: TodoEditorBuilder {

    func build(initTodoItem: TodoItem?) -> TodoEditorVIPER {
        let dependencies = TodoEditorDependencies(
            appViewParams: AppViewParams(
                backgroundLightColor: Colors.backgroundLightColor,
                highPriorityMark: Images.highPriorityMark,
                lowPriorityMark: Images.lowPriorityMark
            )
        )

        return TodoEditorVIPERImpl(todoItem: initTodoItem,
                                   viewParams: dependencies.viewParams,
                                   networkIndicatorBuilder: dependencies.networkIndicatorBuilder)
    }
}
