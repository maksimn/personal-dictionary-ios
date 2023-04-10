//
//  AppBuilder.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 07.02.2023.
//

import ComposableArchitecture
import CoreModule
import UIKit

public final class AppBuilder: ViewControllerBuilder {

    private let logger = LoggerImpl(category: "TodoList.App")

    private lazy var cache = TodoListCacheImp(logger: logger)

    private lazy var deadCache = DeadCacheImp(logger: logger)

    private let service = {
        let token = ""

        return TodoListServiceImp(
            networking: TodoListNetworkingImp(
                urlString: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net",
                headers: [
                    "Authorization": token,
                    "Content-Type": "application/json"
                ],
                httpClient: HttpClientImpl()
            )
        )
    }()

    private lazy var syncWithRemoteTodosEffect = SyncWithRemoteTodosEffect(
        cache: cache,
        deadCache: deadCache,
        service: service
    )

    private lazy var getRemoteTodosEffect = GetRemoteTodosEffect(
        cache: cache,
        service: service,
        syncEffect: syncWithRemoteTodosEffect
    )

    private lazy var insertTodoIntoCacheEffect = InsertTodoIntoCacheEffect(
        cache: cache,
        logger: logger,
        syncEffect: syncWithRemoteTodosEffect
    )

    private lazy var updateTodoInCacheEffect = UpdateTodoInCacheEffect(
        cache: cache,
        logger: logger,
        syncEffect: syncWithRemoteTodosEffect
    )

    private lazy var createTodoEffect = CreateTodoEffect(
        cache: cache,
        service: service,
        insertTodoIntoCacheEffect: insertTodoIntoCacheEffect,
        updateTodoInCacheEffect: updateTodoInCacheEffect,
        logger: logger
    )

    private lazy var updateTodoEffect = UpdateTodoEffect(
        cache: cache,
        service: service,
        updateTodoInCacheEffect: updateTodoInCacheEffect,
        logger: logger
    )

    private lazy var deleteTodoEffect = DeleteTodoEffect(
        cache: cache,
        deadCache: deadCache,
        service: service,
        syncEffect: syncWithRemoteTodosEffect,
        logger: logger
    )

    public init() { }

    public func build() -> UIViewController {
        let app = App(
            loadCachedTodosEffect: LoadCachedTodosEffect(cache: cache),
            getRemoteTodosEffect: getRemoteTodosEffect,
            replaceAllTodosInCacheEffect: ReplaceAllTodosInCacheEffect(cache: cache, logger: logger),
            createTodoEffect: createTodoEffect,
            updateTodoEffect: updateTodoEffect,
            deleteTodoEffect: deleteTodoEffect
        )._printChanges()
        let store = StoreOf<App>(
            initialState: App.State(),
            reducer: app
        )
        let mainScreenBuilder = MainScreenBuilder(store: store)
        let mainScreen = mainScreenBuilder.build()

        return mainScreen
    }
}
