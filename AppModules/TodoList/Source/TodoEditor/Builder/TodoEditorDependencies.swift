//
//  TodoEditorBuilderImpl.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 03.01.2022.
//

import CoreModule

final class TodoEditorDependencies {

    let viewParams: TodoEditorViewParams
    let networkIndicatorBuilder: NetworkIndicatorBuilder

    init(appViewParams: AppViewParams) {
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
        networkIndicatorBuilder = NetworkIndicatorBuilderImpl(
            httpRequestCounter: TodoListServiceGraphOne(
                todoListCache: MOTodoListCache.instance,
                coreService: URLSessionCoreService(),
                logger: LoggerImpl(isLoggingEnabled: true),
                todoCoder: JSONCoderImpl(),
                notificationCenter: NotificationCenter.default
            ).service.httpRequestCounter
        )
    }
}
