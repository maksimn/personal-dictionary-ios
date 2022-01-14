//
//  TodoListAppBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 16.12.2021.
//

import CoreModule

public struct TodoListAppParams {

    public let routingButtonTitle: String

    public init(routingButtonTitle: String) {
        self.routingButtonTitle = routingButtonTitle
    }
}

public final class TodoListAppBuilderImpl: TodoListAppBuilder {

    private let appParams: TodoListAppParams

    public init(appParams: TodoListAppParams) {
        self.appParams = appParams
    }

    public func build() -> TodoListApp {
        TodoListAppImpl(appParams: appParams)
    }
}
