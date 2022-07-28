//
//  ToggableItemListBuilderImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import RxSwift

protocol TodoItemCUDSubscriber: CreatedTodoItemSubscriber,
                                UpdatedTodoItemSubscriber,
                                DeletedTodoItemSubscriber,
                                MergeItemsWithRemoteSubscriber { }

final class ToggableItemListBuilderImp: ToggableItemListBuilder {

    func build() -> ToggableItemListGraph {
        ToggableItemListGraphImp(
            service: TodoListServiceGraphOne(
                todoListCache: MOTodoListCache.instance,
                coreService: URLSessionCoreService(),
                logger: LoggerImpl(isLoggingEnabled: true),
                todoCoder: JSONCoderImpl(),
                notificationCenter: NotificationCenter.default
            ).service,
            cudSubscriber: TodoItemCUDSubscriberImp()
        )
    }

    private class TodoItemCUDSubscriberImp: TodoItemCUDSubscriber {

        var todoItem: Observable<TodoItem> {
            CreatedTodoItemStreamImp.instance.todoItem
        }

        var updatedTodoItemData: Observable<UpdatedTodoItemData> {
            UpdatedTodoItemStreamImp.instance.updatedTodoItemData
        }

        var deletedTodoItem: Observable<TodoItem> {
            DeletedTodoItemStreamImp.instance.deletedTodoItem
        }

        var mergeSuccess: Observable<Void> {
            MergeItemsWithRemoteStreamImp.instance.mergeSuccess
        }
    }
}
