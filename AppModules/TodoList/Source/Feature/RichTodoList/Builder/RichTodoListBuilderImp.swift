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
        let logger = LoggerImpl(category: "TodoList.RichTodoList")
        let networkingService = NetworkingServiceImp(
            urlString: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net",
            headers: [
                "Authorization": token,
                "Content-Type": "application/json"
            ],
            httpClient: HttpClientImpl(),
            todoCoder: JSONCoderImpl()
        )
        let persistentContainer = TodoListPersistentContainer(logger: logger)
        let service = TodoListServiceOne(
            isRemotingEnabled: !token.isEmpty,
            cache: TodoListCacheImp(
                container: persistentContainer,
                logger: logger
            ),
            deadItemsCache: DeadItemsCacheImp(
                container: persistentContainer,
                logger: logger
            ),
            logger: logger,
            networking: networkingService,
            httpRequestCounterPublisher: HttpRequestCounterStreamImp.instance,
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
