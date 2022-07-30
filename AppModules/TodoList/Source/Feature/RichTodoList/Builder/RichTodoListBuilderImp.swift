//
//  RichTodoListBuilderImp.swift
//  TodoList
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import RxSwift

protocol TodoItemCUDSubscriber: CreatedTodoItemSubscriber, UpdatedTodoItemSubscriber, DeletedTodoItemSubscriber,
    MergeItemsWithRemoteSubscriber { }

final class RichTodoListBuilderImp: RichTodoListBuilder {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func build() -> RichTodoListGraph {
        let token = ""
        let logger = LoggerImpl(isLoggingEnabled: true)
        let networkingService = DefaultNetworkingService(
            urlString: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net",
            headers: [
                "Authorization": token,
                "Content-Type": "application/json"
            ],
            coreService: URLSessionCoreService(),
            todoCoder: JSONCoderImpl()
        )
        let httpRequestCounter = HttpRequestCounterOne(
            httpRequestCounterPublisher: HttpRequestCounterStreamImp.instance
        )
        let service = TodoListServiceOne(
            isRemotingEnabled: !token.isEmpty,
            cache: MOTodoListCache(logger: logger),
            logger: logger,
            networking: networkingService,
            сounter: httpRequestCounter,
            mergeItemsWithRemotePublisher: MergeItemsWithRemoteStreamImp.instance
        )

        return RichTodoListGraphImp(
            service: service,
            cudSubscriber: TodoItemCUDSubscriberImp(),
            navigationController: navigationController
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
