//
//  NetwordIndicatorBuilderImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

import CoreModule

final class NetworkIndicatorBuilderImpl: NetworkIndicatorBuilder {

    func build() -> NetworkIndicatorVIPER {
        NetworkIndicatorVIPERImpl(
            httpRequestCounter: TodoListServiceGraphOne(
                todoListCache: MOTodoListCache.instance,
                coreService: URLSessionCoreService(),
                logger: LoggerImpl(isLoggingEnabled: true),
                todoCoder: JSONCoderImpl()
            ).service.httpRequestCounter
        )
    }
}
