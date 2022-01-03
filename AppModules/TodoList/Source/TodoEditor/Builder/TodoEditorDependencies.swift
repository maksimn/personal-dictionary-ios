//
//  TodoEditorBuilderImpl.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.01.2022.
//

final class TodoEditorDependencies {

    let viewParams: TodoEditorViewParams
    let networkIndicatorBuilder: NetworkIndicatorBuilder

    init(service: TodoListService,
         appViewParams: AppViewParams) {
        viewParams = TodoEditorViewParams(
            backgroundLightColor: appViewParams.backgroundLightColor,
            prioritySegmentedControlItems: [appViewParams.lowPriorityMark, "нет", appViewParams.highPriorityMark],
            newTodoPlaceholder: "Что надо сделать?",
            priority: "Важность",
            shouldBeDoneBefore: "Сделать до",
            remove: "Удалить",
            navBar: TodoEditorNavBarParams(
                save: "Сохранить",
                todo: "Дело",
                cancel: "Отменить"
            )
        )
        networkIndicatorBuilder = NetworkIndicatorBuilderImpl(httpRequestCounter: service.httpRequestCounter)
    }
}
